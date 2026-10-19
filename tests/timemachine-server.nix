{
  name = "timemachine-server";
  nodes = {
    server = {
      pilz.services.timemachine-server.enable = true;
      users.users.marie.isNormalUser = true;
      systemd.tmpfiles.rules = [ "d /srv/timemachine 0700 marie users -" ];
    };
    client =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.samba ];
      };
  };

  testScript = ''
    start_all()
    server.wait_for_unit("samba-smbd.service")
    server.wait_for_open_port(445)
    server.succeed("printf 'hunter2\\nhunter2\\n' | smbpasswd -s -a marie")
    client.wait_for_unit("multi-user.target")

    with subtest("marie can write to the share"):
        client.succeed("echo backup > /tmp/backup.txt")
        client.succeed("smbclient //server/tm_share -U marie%hunter2 -c 'put /tmp/backup.txt backup.txt'")
        owner, mode = server.succeed("stat -c '%U %a' /srv/timemachine/backup.txt").split()
        assert owner == "marie", owner
        assert mode.endswith("00"), mode

    with subtest("guests and wrong passwords are refused"):
        client.fail("smbclient //server/tm_share -N -c ls")
        client.fail("smbclient //server/tm_share -U marie%wrong -c ls")
  '';
}
