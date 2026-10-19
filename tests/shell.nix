{
  name = "shell";
  nodes.machine = {
    pilz.shell.enable = true;
    users.users.alice.isNormalUser = true;
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")

    with subtest("zsh is the default shell"):
        shell = machine.succeed("getent passwd alice | cut -d: -f7").strip()
        assert shell.endswith("/bin/zsh"), shell

    with subtest("starship prompt is set up in interactive zsh"):
        # starship init is skipped for TERM=dumb
        prompt = machine.succeed("runuser -u alice -- env TERM=xterm-256color zsh -ic 'print -r -- $PROMPT'")
        assert "starship" in prompt, prompt

    with subtest("autosuggestions are loaded"):
        machine.succeed("runuser -u alice -- zsh -ic 'typeset -f _zsh_autosuggest_start >/dev/null'")
  '';
}
