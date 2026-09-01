{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.pilz.darwin.shell.enable = lib.mkEnableOption "";
  config = lib.mkIf config.pilz.darwin.shell.enable {

    programs = {
      zsh = {
        enable = true;
        autosuggestion = {
          enable = true;
        };
      };

      zsh.initContent = lib.mkOrder 1500 ''
        eval "$(direnv hook zsh)"
        export DOCKER_HOST="unix://$HOME/.colima/default/docker.sock"
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
  };
}
