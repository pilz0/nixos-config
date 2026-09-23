{
  pkgs,
  pkgs-unstable,
  config,
  ...
}:
{
  environment.systemPackages =
    (with pkgs; [
      firefox
      fastfetch
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
      rclone
      pavucontrol
      openconnect
      spotifyd
      killall
      gnupg
      vlc
      yt-dlp
      supertuxkart
    ])
    ++ (with pkgs-unstable; [
      ollama
      crosspipe
    ]);

  services = {
    vscode-server.enable = true;
  };

  virtualisation = {
    docker.enable = true;
    docker.package = pkgs.docker_29;
  };

  programs = {
    nix-ld.enable = true;
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
          email = "48645439+pilz0@users.noreply.github.com";
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
