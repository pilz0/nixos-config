{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    mitmproxy
    ledger-live-desktop
    gimp
    thunderbird
    firefox
    neofetch
    alacritty
    signal-desktop
    nil
    speedtest-cli
    filezilla
    docker
    libreoffice
    python3
    obs-studio
    wireshark-qt
    vlc
    terraform
    prusa-slicer
    nixfmt-rfc-style
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
    wireshark-qt
    kubernetes
    kind
    networkmanager-openvpn
    # Google Cloud SDK with additional components
    (google-cloud-sdk.withExtraComponents [
      google-cloud-sdk.components.gke-gcloud-auth-plugin
    ])
  ];

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
        catppuccin.catppuccin-vsc
      ];
    };
  };
}
