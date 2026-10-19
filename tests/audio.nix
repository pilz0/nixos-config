{
  name = "audio";
  nodes.machine =
    { pkgs, ... }:
    {
      pilz.audio.enable = true;
      users.users.alice = {
        isNormalUser = true;
        linger = true;
      };
      environment.systemPackages = [ pkgs.pulseaudio ];
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.wait_for_unit("user@1000.service")

    def as_alice(cmd):
        return f"runuser -u alice -- env XDG_RUNTIME_DIR=/run/user/1000 {cmd}"

    with subtest("pipewire runs in the user session"):
        machine.wait_until_succeeds(as_alice("systemctl --user is-active pipewire.socket"))
        machine.wait_until_succeeds(as_alice("systemctl --user is-active pipewire-pulse.socket"))

    with subtest("pulse clients talk to pipewire"):
        machine.wait_until_succeeds(as_alice("pactl info | grep -q 'PipeWire'"))

    with subtest("pulseaudio daemon is not running"):
        machine.fail("pgrep -x pulseaudio")
  '';
}
