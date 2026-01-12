{
  pkgs,
  ...
}:
{
  users.defaultUserShell = pkgs.zsh;

  programs = {
    zsh = {
      enable = true;
      autosuggestions = {
        enable = true;
      };
    };

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
