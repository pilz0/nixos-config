{
  pkgs,
  pkgs-unstable,
  config,
  ...
}:
let
  jetson-stats = pkgs.callPackage ../../pkgs/jetson-stats.nix { };
in
{
  environment.systemPackages =
    (with pkgs; [
      jetson-stats
      fastfetch
      alacritty
      python3
      cmatrix
      btop
      wget
      pavucontrol
      killall
      gnupg
      vlc
      yt-dlp
      supertuxkart
      tailscale
    ])
    ++ (with pkgs-unstable; [
      crosspipe
    ]);

  users.groups.jtop.members = [
    "marie"
    "emily"
  ];
  systemd.services.jtop = {
    description = "jtop service";
    after = [ "systemd-modules-load.service" ];
    wantedBy = [ "multi-user.target" ];
    environment.JTOP_SERVICE = "True";
    path =
      (with pkgs.nvidia-jetpack; [
        l4t-tools
        l4t-nvpmodel
        l4t-nvfancontrol
      ])
      ++ (with pkgs; [
        util-linux
        procps
        which
        bash
      ]);
    serviceConfig = {
      ExecStart = "${jetson-stats}/bin/jtop --force";
      StateDirectory = "jtop";
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };

  virtualisation = {
    docker.enable = true;
    docker.package = pkgs.docker_29;
  };

  programs = {

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
