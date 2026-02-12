{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs = {
    zsh = {
      enable = true;
      autosuggestion = {
        enable = true;
      };
    };

    age.secrets = {
      work-bw-session = {
        file = ../../secrets/work-bw-session.age;
        path = "${config.home.homeDirectory}/.agenix/secrets/work-bw-session";
      };
    };

    programs.zsh.initContent = lib.mkOrder 1500 ''
      eval "$(direnv hook zsh)"
      export DOCKER_HOST="unix://$HOME/.colima/default/docker.sock"
      export BW_SESSION=$(${pkgs.coreutils}/bin/cat ${config.age.secrets.work-bw-session.path})
    '';

    starship = {
      enable = true;
      settings = {
        add_newline = true;
        command_timeout = 1300;
        scan_timeout = 50;
        format = "$nix_shell$git_branch$git_commit$git_state$git_status\n$username$hostname$directory";
        character = {
          success_symbol = "[](bold green) ";
          error_symbol = "[✗](bold red) ";
        };
      };
    };
  };
}
