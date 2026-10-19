{ hostPkgs, ... }:
let
  # throwaway age identity + a self-signed cert/key encrypted to it
  ageFixture =
    hostPkgs.runCommand "nginx-age-fixture"
      {
        nativeBuildInputs = [
          hostPkgs.age
          hostPkgs.openssl
        ];
      }
      ''
        mkdir $out
        age-keygen -o $out/key.txt
        openssl req -x509 -newkey ed25519 -nodes -days 1 -subj /CN=server -keyout key.pem -out cert.pem
        age -r "$(age-keygen -y $out/key.txt)" -o $out/cert.age cert.pem
        age -r "$(age-keygen -y $out/key.txt)" -o $out/key.age key.pem
      '';
in
{
  name = "nginx";
  nodes = {
    server =
      { lib, pkgs, ... }:
      {
        pilz.services.nginx = {
          enable = true;
          enableMonitoring = true;
        };

        age.identityPaths = [ "${ageFixture}/key.txt" ];
        age.secrets.cloudflare_cert.file = lib.mkForce "${ageFixture}/cert.age";
        age.secrets.cloudflare_key.file = lib.mkForce "${ageFixture}/key.age";

        services.nginx.virtualHosts.server.locations."/ip".return = "200 $remote_addr";
        networking.firewall.allowedTCPPorts = [ 80 ];
        environment.systemPackages = [ pkgs.curl ];
      };
    client =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.curl ];
      };
  };

  testScript =
    { nodes, ... }:
    ''
      start_all()
      server.wait_for_unit("nginx.service")
      server.wait_for_unit("prometheus-nginx-exporter.service")
      server.wait_for_open_port(80)
      server.wait_for_open_port(9113)
      client.wait_for_unit("multi-user.target")

      with subtest("cloudflare origin cert is readable by nginx"):
          server.succeed("runuser -u nginx -- grep -q 'BEGIN CERTIFICATE' /run/agenix/cloudflare_cert")
          server.succeed("runuser -u nginx -- grep -q 'PRIVATE KEY' /run/agenix/cloudflare_key")

      with subtest("status page and exporter work"):
          server.succeed("curl -fsS http://localhost/nginx_status | grep -q 'Active connections'")
          server.wait_until_succeeds("curl -fsS http://localhost:9113/metrics | grep -q '^nginx_up 1'")

      with subtest("exporter is not reachable from random hosts"):
          client.fail("curl -4 -fsS --max-time 5 http://server:9113/metrics")

      with subtest("CF-Connecting-IP is only trusted from cloudflare"):
          ip = client.succeed("curl -4 -fsS -H 'CF-Connecting-IP: 1.2.3.4' http://server/ip").strip()
          assert ip == "${nodes.client.networking.primaryIPAddress}", ip
    '';
}
