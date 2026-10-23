{ hostPkgs, ... }:
let
  keys = import "${hostPkgs.path}/nixos/tests/ssh-keys.nix" hostPkgs;
  # throwaway age identity + the builder ssh key encrypted to it
  ageFixture =
    hostPkgs.runCommand "nixos-builder-client-age-fixture" { nativeBuildInputs = [ hostPkgs.age ]; }
      ''
        mkdir $out
        age-keygen -o $out/key.txt
        age -r "$(age-keygen -y $out/key.txt)" -o $out/ssh.age ${keys.snakeOilEd25519PrivateKey}
      '';
in
{
  name = "nixos-builder-client";
  nodes = {
    builder = {
      services.openssh = {
        enable = true;
        hostKeys = [
          {
            type = "ed25519";
            path = "/etc/ssh/ssh_host_ed25519_key";
          }
        ];
      };
      # fixed host key so the client can pin it
      environment.etc."ssh/ssh_host_ed25519_key" = {
        source = keys.snakeOilEd25519PrivateKey;
        mode = "0600";
      };
      users.users.root.openssh.authorizedKeys.keys = [ keys.snakeOilEd25519PublicKey ];
      virtualisation.writableStore = true;
    };
    client =
      { lib, ... }:
      {
        pilz.services.nixosBuilderClient = {
          enable = true;
          builderHost = "builder";
        };
        users.users.marie.isNormalUser = true;

        age.identityPaths = [ "${ageFixture}/key.txt" ];
        age.secrets.nixbuildssh.file = lib.mkForce "${ageFixture}/ssh.age";
        programs.ssh.knownHosts.builder.publicKey = keys.snakeOilEd25519PublicKey;

        nix.settings.substituters = lib.mkForce [ ];
        virtualisation.writableStore = true;
      };
  };

  testScript = ''
    expr = "derivation { name = \"remote-build\"; system = \"x86_64-linux\"; builder = \"/bin/sh\"; args = [ \"-c\" \"echo remote > $out\" ]; nonce = builtins.currentTime; }"

    start_all()
    builder.wait_for_unit("sshd.service")
    builder.wait_for_open_port(22)
    client.wait_for_unit("multi-user.target")

    with subtest("builder ssh key is owned by marie"):
        client.succeed("test \"$(stat -c %U /run/agenix/nixbuildssh)\" = marie")

    with subtest("builder is registered"):
        nix_machines = client.succeed("cat /etc/nix/machines")
        assert "ssh-ng://root@builder" in nix_machines, nix_machines
        assert "/run/agenix/nixbuildssh" in nix_machines, nix_machines

    with subtest("builds are offloaded to the builder"):
        out = client.succeed(f"nix-build --max-jobs 0 --no-out-link -E '{expr}'").strip()
        # the sandbox hostname is always "localhost", so check the builder's store instead
        builder.succeed(f"nix-store --check-validity {out}")
  '';
}
