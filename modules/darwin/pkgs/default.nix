{
  pkgs,
  pkgs-unstable, # You must add this to the arguments
  ...
}:
{
  environment.systemPackages =
    (with pkgs; [
      ansible
      tmux
      vim
      neofetch
      zsh
      nmap
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
      dig
      wireguard-tools
      direnv
      colmena
      jellyfin-mpv-shim
      mpv-unwrapped
      stats
      git-lfs
      openssl
      pwgen
      php
      ddev
      uv
      jq
      yq
      firefox
      google-chrome
      jetbrains.phpstorm
      openvpn
      bitwarden-desktop
      istat-menus
      dash
      spotify
      nil
      nixd
      bitwarden-cli
      python314
      gh
      pre-commit
      # antigravity
    ])
    ++ (with pkgs-unstable; [
      # caffeine on stable does not support aarch64-darwin
      caffeine
      # element-desktop
    ]);

  # why is docker aahhh
  # https://github.com/nix-darwin/nix-darwin/issues/1182
  launchd.agents."colima.default" = {
    command = "${pkgs.colima}/bin/colima start --cpu 6 --memory 16 --foreground";
    serviceConfig = {
      Label = "com.colima.default";
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/Users/pilz/.colima/default/daemon/launchd.stdout.log";
      StandardErrorPath = "/Users/pilz/.colima/default/daemon/launchd.stderr.log";
      EnvironmentVariables = {
        PATH = "${pkgs.colima}/bin:${pkgs.docker}/bin:/usr/bin:/bin:/usr/sbin:/sbin";
      };
    };
  };
}
