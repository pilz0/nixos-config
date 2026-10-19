{
  name = "nextcloud";
  nodes = {
    server =
      { lib, ... }:
      {
        pilz.services.nextcloud.enable = true;
        services.nginx.virtualHosts."cloud.freifick.net" = {
          enableACME = lib.mkForce false;
          forceSSL = lib.mkForce false;
        };
        networking.firewall.allowedTCPPorts = [ 80 ];
        virtualisation.memorySize = 2048;
      };
    client =
      { nodes, pkgs, ... }:
      {
        networking.hosts.${nodes.server.networking.primaryIPAddress} = [ "cloud.freifick.net" ];
        environment.systemPackages = [ pkgs.curl ];
      };
  };

  testScript = ''
    import json

    start_all()
    server.wait_for_unit("multi-user.target")
    # oneshot without RemainAfterExit, so it's inactive once done
    assert server.get_unit_info("nextcloud-setup")["Result"] == "success"
    server.wait_for_unit("phpfpm-nextcloud.service")
    server.wait_for_unit("nginx.service")
    server.wait_for_open_port(80)

    with subtest("nextcloud is installed"):
        status = json.loads(client.succeed("curl -fsS http://cloud.freifick.net/status.php"))
        assert status["installed"], status
        assert not status["maintenance"], status

    with subtest("admin can use webdav"):
        client.succeed("echo hi > /tmp/hello.txt")
        client.succeed(
            "curl -fsS -u root:S4uhdNRVZntUns -T /tmp/hello.txt "
            "http://cloud.freifick.net/remote.php/dav/files/root/hello.txt"
        )
        out = client.succeed(
            "curl -fsS -u root:S4uhdNRVZntUns http://cloud.freifick.net/remote.php/dav/files/root/hello.txt"
        )
        assert out.strip() == "hi", out

    with subtest("wrong password is refused"):
        client.fail("curl -fsS -u root:wrong http://cloud.freifick.net/remote.php/dav/files/root/")
  '';
}
