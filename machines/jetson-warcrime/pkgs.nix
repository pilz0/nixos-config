{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    thunderbird
    firefox
    neofetch
    alacritty
    signal-desktop
    libreoffice
    python3
    vlc
    nixfmt-rfc-style
    cmatrix
    btop
    wget
    restic
    helvum
    rclone
    pavucontrol
    openconnect
    spotifyd
    killall
    gnupg
    vlc
  ];

  virtualisation = {
    docker.enable = true;
  };

  programs = {
    firefox.policies = {
      DisablePocket = true;
      DisableTelemetry = true;
      PasswordManagerEnabled = false;
      cookies = "reject";
      DisableFirefoxStudies = true;
    };

    git = {
      config = {
        user = {
          name = "pilz0";
          email = "marie0@riseup.net";
        };
      };
    };
    
    vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        golang.go
        jnoortheen.nix-ide
      ];
    };
  };
}
