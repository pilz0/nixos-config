{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.jetpack.nixosModules.default
    inputs.determinate.nixosModules.default
    inputs.catppuccin.nixosModules.catppuccin
    inputs.vscode-server.nixosModules.default
    ../../modules/ssh
    ../../modules/ssh-users
    ../../modules/shell
    ../../modules/common/pkgs
    ./nvidia.nix
    ./graphics.nix
    ./audio.nix
    ./pkgs.nix
    ./hardware-configuration.nix
  ];

  pilz = {
    deployment = {
      targetHost = "da-home.as214958.net";
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "jetson-warcrime";
  networking.firewall.allowedTCPPorts = [ 22 ];

  services.vscode-server.enable = true;
  programs.nix-ld.enable = true;

  time = {
    timeZone = "Europe/Berlin";
  };
  i18n = {
    defaultLocale = "de_DE.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };
  console = {
    keyMap = "de";
  };

  nix = {
    optimise = {
      automatic = true;
      randomizedDelaySec = "0";
      dates = [
        "03:45"
      ];
    };
    settings.experimental-features = [
      "nix-command"
      "flakes"
      "cgroups"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";
}
