{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  options.pilz.pkgs.default.enable = lib.mkEnableOption "";
  config = lib.mkIf config.pilz.pkgs.default.enable {

    environment.systemPackages = with pkgs; [
      ansible
      tmux
      vim
      fastfetch
      zsh
      nmap
      traceroute
      git
      btop
      wget
      rclone
      restic
      gtop
      freerdp
      killall
      picocom
      gnumake
      curl
      ddclient
      dig
      devenv
      wireguard-tools
      direnv
      colmena
      inputs.nixos-needsreboot.packages.${pkgs.system}.default
    ];
  };
}
