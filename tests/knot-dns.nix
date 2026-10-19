{ hostPkgs, ... }:
let
  tsigName = "test-tsig";
  tsigSecret = "dGhpcy1pcy1hLXRlc3QtdHNpZy1zZWNyZXQtMTIzNDU=";
  # throwaway age identity + a tsig key file encrypted to it
  ageFixture = hostPkgs.runCommand "knot-dns-age-fixture" { nativeBuildInputs = [ hostPkgs.age ]; } ''
    mkdir $out
    age-keygen -o $out/key.txt
    cat > tsig.conf <<CONF
    key:
      - id: ${tsigName}
        algorithm: hmac-sha256
        secret: ${tsigSecret}
    CONF
    age -r "$(age-keygen -y $out/key.txt)" -o $out/tsig.age tsig.conf
  '';
in
{
  name = "knot-dns";
  nodes = {
    server =
      { lib, ... }:
      {
        pilz.services.knot-dns.enable = true;

        age.identityPaths = [ "${ageFixture}/key.txt" ];
        age.secrets.tsig_ns.file = lib.mkForce "${ageFixture}/tsig.age";

        networking.firewall = {
          allowedTCPPorts = [ 53 ];
          allowedUDPPorts = [ 53 ];
        };
      };
    client =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.dig ];
      };
  };

  testScript = ''
    zone = "7.1.0.f.2.0.f.8.e.0.a.2.ip6.arpa"

    start_all()
    server.wait_for_unit("knot.service")
    server.wait_for_open_port(53)
    client.wait_for_unit("multi-user.target")

    with subtest("reverse zone is authoritative"):
        out = client.succeed(f"dig @server SOA {zone} +norec")
        assert "status: NOERROR" in out, out
        assert " aa" in out.split("flags:")[1].split(";")[0], out

    with subtest("PTR records resolve"):
        out = client.succeed("dig @server -x 2a0e:8f02:f017::2 +short").strip()
        assert out == "web1.ams1.as214958.net.", out

    # signed queries need an acl allowing the key, the zone has none, so check the config instead
    with subtest("tsig key from the agenix secret is loaded"):
        out = server.succeed("knotc conf-read key.id")
        assert "${tsigName}" in out, out
  '';
}
