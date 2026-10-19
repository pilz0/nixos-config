{
  name = "diyhrt-web";
  nodes = {
    server =
      { lib, ... }:
      {
        pilz.services.diyhrt-web.enable = true;
        services.nginx.virtualHosts."hrt.pilz.foo" = {
          enableACME = lib.mkForce false;
          forceSSL = lib.mkForce false;
        };
        networking.firewall.allowedTCPPorts = [ 80 ];
      };
    client =
      { nodes, pkgs, ... }:
      {
        networking.hosts.${nodes.server.networking.primaryIPAddress} = [ "hrt.pilz.foo" ];
        environment.systemPackages = [ pkgs.curl ];
      };
  };

  testScript = ''
    start_all()
    server.wait_for_unit("nginx.service")
    server.wait_for_open_port(80)

    with subtest("index is served"):
        client.succeed("curl -fsS http://hrt.pilz.foo/ | grep -q '<title>hrt.pilz.foo'")

    with subtest("webroot is readable by nginx"):
        server.succeed("runuser -u nginx -- test -r /etc/diyhrt-web/index.html")
  '';
}
