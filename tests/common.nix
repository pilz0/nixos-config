{
  name = "common";
  # the module sets nixpkgs.config.allowUnfree
  node.pkgsReadOnly = false;
  nodes.machine = {
    pilz.common.enable = true;
    virtualisation.memorySize = 2048;
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")

    with subtest("timezone and locale"):
        tz = machine.succeed("readlink -f /etc/localtime")
        assert tz.strip().endswith("Europe/Berlin"), tz
        machine.succeed("grep -q 'LANG=de_DE.UTF-8' /etc/locale.conf")

    with subtest("systemd-resolved is running"):
        machine.wait_for_unit("systemd-resolved.service")
        machine.succeed("resolvectl status")

    with subtest("nix settings"):
        features = machine.succeed("nix config show experimental-features")
        for f in ["nix-command", "flakes", "pipe-operators"]:
            assert f in features, features
        trusted = machine.succeed("nix config show trusted-users")
        assert "root" in trusted and "@wheel" in trusted, trusted
        machine.succeed("nix config show substituters | grep -q cache.kyouma.net")

    with subtest("gc and optimise timers exist"):
        machine.succeed("systemctl cat nix-gc.timer nix-optimise.timer")

    with subtest("default packages are installed"):
        for cmd in ["tmux", "vim", "git", "dig", "curl", "btop"]:
            machine.succeed(f"command -v {cmd}")
  '';
}
