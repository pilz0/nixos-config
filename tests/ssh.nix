{ hostPkgs, ... }:
let
  keys = import "${hostPkgs.path}/nixos/tests/ssh-keys.nix" hostPkgs;
in
{
  name = "ssh";
  nodes = {
    server = {
      pilz.services.ssh.enable = true;
      users.users.root.openssh.authorizedKeys.keys = [
        keys.snakeOilEd25519PublicKey
        # ecdsa-sha2-nistp256, not in the allowed key types
        keys.snakeOilPublicKey
      ];
    };
    client = { };
  };

  testScript = ''
    ssh = "ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

    start_all()
    server.wait_for_unit("sshd.service")
    server.wait_for_open_port(22)

    client.succeed("install -m 600 ${keys.snakeOilEd25519PrivateKey} /root/id_ed25519")
    client.succeed("install -m 600 ${keys.snakeOilPrivateKey} /root/id_ecdsa")

    with subtest("host key is ed25519 at /etc/keys"):
        server.succeed("test -s /etc/keys/ssh_host_ed25519_key")
        client.succeed(f"{ssh} -i /root/id_ed25519 -o HostKeyAlgorithms=ssh-ed25519 root@server true")

    with subtest("root can log in with an ed25519 key"):
        client.succeed(f"{ssh} -i /root/id_ed25519 root@server true")

    with subtest("non-ed25519 keys are rejected"):
        client.fail(f"{ssh} -i /root/id_ecdsa -o IdentitiesOnly=yes root@server true")

    with subtest("only publickey auth is offered"):
        out = client.fail(f"{ssh} -v -o PreferredAuthentications=none root@server true 2>&1")
        assert "Authentications that can continue: publickey\n" in out, out

    with subtest("weak ciphers, macs and kex are refused"):
        client.fail(f"{ssh} -i /root/id_ed25519 -c aes128-ctr root@server true")
        client.fail(f"{ssh} -i /root/id_ed25519 -m hmac-sha2-256 root@server true")
        client.fail(f"{ssh} -i /root/id_ed25519 -o KexAlgorithms=diffie-hellman-group14-sha256 root@server true")
  '';
}
