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
    beeper
    ollama
    qbittorrent
    spicetify-cli
    signal-desktop
    nil
    zed-editor
    speedtest-cli
    filezilla
    docker
    vscode
    libreoffice
    python3
    veracrypt
    obs-studio
    discord
    wireshark-qt
    superTuxKart
    vlc
    terraform
    terraformer
    prusa-slicer
    nixfmt-rfc-style
    cmatrix
    btop
    wget
    restic
    chromium
    helvum
    lutris
    polychromatic
    rclone
    joplin-desktop
    woeusb
    antimicrox
    pavucontrol
    tor-browser
    drawio
    google-chrome
    gnome-themes-extra
    catppuccin-gtk
    spotify
    betterdiscordctl
    openconnect
    freerdp
    killall
    python312Packages.shodan
    python312Packages.selenium
    selenium-manager
    python311Packages.selenium
    gdown
    gnomeExtensions.user-themes
    gnomeExtensions.media-controls
    gnomeExtensions.vitals
    python311Packages.pip
    gnome-tweaks
    vesktop
    brlaser
    gnupg
    pinentry-tty
    vlc
    docker-compose
    telegram-desktop
    m4
    xorg.libXi
    xorg.libXmu
    freeglut
    xorg.libXext
    xorg.libX11
    xorg.libXv
    xorg.libXrandr
    metasploit
    ecryptfs
    gnumake
    wireshark-qt
    awscli
    kubernetes
    kind
    doctl
    # Google Cloud SDK with additional components
    (google-cloud-sdk.withExtraComponents [
      google-cloud-sdk.components.gke-gcloud-auth-plugin
    ])
  ];

  programs.firefox.policies = {
    DisablePocket = true;
    DisableTelemetry = true;
    PasswordManagerEnabled = false;
    cookies = "reject";
    DisableFirefoxStudies = true;
  };

  services.tailscale.enable = true;
  programs.steam.enable = true;

  programs.zsh.shellAliases = {
    backup = "restic -r rclone:onedrive:/backup/server backup --verbose /home";
  };
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
