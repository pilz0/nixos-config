{ hostPkgs, ... }:
let
  # throwaway age identity + a tor family key encrypted to it
  ageFixture =
    hostPkgs.runCommand "tor-relay-age-fixture"
      {
        nativeBuildInputs = [
          hostPkgs.age
          hostPkgs.tor
        ];
      }
      ''
        mkdir $out
        age-keygen -o $out/key.txt
        HOME=$TMPDIR tor --keygen-family test >/dev/null
        age -r "$(age-keygen -y $out/key.txt)" -o $out/family.age test.secret_family_key
      '';
in
{
  name = "tor-relay";
  nodes.machine =
    { lib, pkgs, ... }:
    {
      pilz.services.tor-relay = {
        enable = true;
        orPort = 9001;
      };

      age.identityPaths = [ "${ageFixture}/key.txt" ];
      age.secrets.tor-familiy.file = lib.mkForce "${ageFixture}/family.age";
      # FamilyId must match the real family key, which the test doesn't have
      services.tor.settings.FamilyId = lib.mkForce null;

      environment.systemPackages = [ pkgs.curl ];
    };

  testScript = ''
    machine.wait_for_unit("tor.service")
    machine.wait_for_open_port(9001)
    machine.wait_for_open_port(9052)

    with subtest("family key is installed for tor"):
        machine.succeed("runuser -u tor -- test -r /var/lib/tor/keys/as214958.secret_family_key")

    with subtest("metrics port is served"):
        machine.wait_until_succeeds("curl -fsS 'http://[::1]:9052/metrics' | grep '^tor_' >/dev/null")

    with subtest("relay is configured as a non-exit relay"):
        torrc = machine.succeed("cat $(systemctl show -p ExecStart --value tor | grep -o '/nix/store/[^ ]*torrc' | head -1)")
        assert "ExitRelay 0" in torrc, torrc
        assert "ContactInfo tor@as214958.net" in torrc, torrc

    with subtest("sudo is disabled"):
        machine.fail("command -v sudo")
  '';
}
