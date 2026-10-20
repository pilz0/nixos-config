{
  pkgs,
  inputs,
  ...
}:
{
  environment.systemPackages =
    (with pkgs; [
      mitmproxy
      ledger-live-desktop
      gimp
      thunderbird
      alacritty
      signal-desktop
      nil
      speedtest-cli
      filezilla
      docker
      libreoffice
      python3
      obs-studio
      wireshark
      vlc
      terraform
      prusa-slicer
      nixfmt
      cmatrix
      btop
      wget
      restic
      chromium
      helvum
      rclone
      woeusb
      pavucontrol
      tor-browser
      drawio
      google-chrome
      spotify
      openconnect
      killall
      android-studio
      gnome-tweaks
      vesktop
      gnupg
      vlc
      pinentry-gnome3
      docker-compose
      telegram-desktop
      gnumake
      wireshark
      kubernetes
      kind
      networkmanager-openvpn
      comma
      android-tools
      tailscale
      gnupg
      github-copilot-cli
      mpv-unwrapped
      spotify
      antigravity-cli
      claude-code
      zotero
      androidenv.androidPkgs.ndk-bundle
      devenv
      rustc
      rustup
    ])
    ++ [
      inputs.agenix.packages.x86_64-linux.default
      inputs.anodyne-api.packages.x86_64-linux.default
      inputs.anodyne-chrp.packages.x86_64-linux.default
      inputs.anodyne-molpic.packages.x86_64-linux.default
      inputs.firefox.packages.x86_64-linux.default
    ];
  catppuccin.autoEnable = true;
  catppuccin.enable = true;
  programs = {
    firefox.policies = {
      DisablePocket = true;
      DisableTelemetry = true;
      PasswordManagerEnabled = false;
      cookies = "reject";
      DisableFirefoxStudies = true;
    };

    steam = {
      enable = true;
    };
    zsh = {
      shellAliases = {
        backup = "restic -r rclone:onedrive:/backup/server backup --verbose /home";
      };
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    vscode = {
      enable = true;
      defaultEditor = true;
      extensions = with pkgs.vscode-extensions; [
        golang.go
        jnoortheen.nix-ide
      ];
    };
  };
}
