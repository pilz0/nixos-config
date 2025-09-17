{
  pkgs,
  ...
}:
{
  programs.zsh = {
    enable = true;
    autosuggestions = {
      enable = true;
    };
    shellAliases = {
      update = "sudo nix flake update /home/marie/nixos-config";
      rebuild = "sudo nixos-rebuild --flake /home/marie/nixos-config";
    };
  };
  users.defaultUserShell = pkgs.zsh;

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      command_timeout = 1300;
      scan_timeout = 50;
      format = "$all$nix_shell$nodejs$lua$golang$rust$php$git_branch$git_commit$git_state$git_status\n$username$hostname$directory";
      character = {
        success_symbol = "[](bold green) ";
        error_symbol = "[✗](bold red) ";
      };
    };
  };
}
