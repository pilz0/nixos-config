{
  ...
}:
{

  imports = [
  ];
  nixpkgs = {
    overlays = [
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = true;
    };
  };

  programs.zsh.shellAliases = {
    backup = "restic -r rclone:onedrive:/backup/server backup --verbose /home";
  };

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
  home = {
    username = "marie";
    homeDirectory = "/home/marie";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
