{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    mitmproxy
    windows10-icons
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
    element-desktop
    filezilla
    docker
    vscode
    libreoffice
    python3
    veracrypt
    discord
    wireshark-qt
    superTuxKart
    vlc
    google-cloud-sdk
    terraform
    terraformer
    prusa-slicer
    nixfmt-rfc-style
    cmatrix
    btop
    wget
    restic
    chromium
    android-studio
    winetricks
    helvum
    lutris
    polychromatic
    rclone
    joplin-desktop
    woeusb
    antimicrox
    pavucontrol
    setserial
    wineWowPackages.wayland
    tor-browser
    chromedriver
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
    jetbrains.idea-ultimate
    gnomeExtensions.user-themes
    gnomeExtensions.media-controls
    gnomeExtensions.vitals
    python311Packages.pip
    gnome-tweaks
    vesktop
    brlaser
    catppuccin-gtk
    telegram-desktop
  ];
}
