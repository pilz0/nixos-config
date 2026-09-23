{
  config,
  inputs,
  lib,
  ...
}:
{
  disabledModules = [
    ../../modules/services/nixarr
  ];

  imports = [
    inputs.jetpack.nixosModules.default
    inputs.determinate.nixosModules.default
    inputs.vscode-server.nixosModules.default
    ./nvidia.nix
    ./graphics.nix
    ./pkgs.nix
    ./hardware-configuration.nix
    ./nixarr.nix
    ./networking.nix
  ];

  pilz = {
    common.enable = true;
    audio.enable = true;
    services.ssh.enable = true;
    shell.enable = true;
    services.nixarr = {
      enable = true;
      wgConfSecretFile = ../../secrets/wg-jetson.age;
      peerPort = 63077;
    };
  };
  security.sudo.wheelNeedsPassword = false;

  nix.settings.trusted-users = [
    "emily"
    "marie"
    "root"
  ];

  users.users = {
    marie = {
      extraGroups = [
        "wheel"
      ];
      isNormalUser = true;
    };
    emily = {
      extraGroups = [
        "wheel"
      ];
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA/+iN407+HsfHbbC3tfdA8Yf4TZ08qXQMb4tb/SDAs+"
      ];
    };
  };

  pilz = {
    deployment = {
      targetUser = "marie";
      targetHost = "192.168.0.225";
      buildOnTarget = true;
    };
  };

  systemd.services.transmission.serviceConfig.RootDirectory = lib.mkForce "";

  networking.nat = {
    enable = true;
    externalInterface = "end0";
    internalInterfaces = [ "wg-br" ];
  };

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

  programs.ssh.knownHosts."eu.nixbuild.net".publicKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIQCZc54poJ8vqawd8TraNryQeJnvH1eLpIDgbiqymM";

  nix = {
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "eu.nixbuild.net";
        protocol = "ssh";
        sshUser = "root";
        sshKey = "/home/marie/nixbuild"; # registered on nixbuild.net
        system = "aarch64-linux";
        maxJobs = 100;
        speedFactor = 10;
        supportedFeatures = [
          "benchmark"
          "big-parallel"
        ];
      }
    ];

    settings.builders-use-substitutes = true;
    settings.experimental-features = [
      "nix-command"
      "flakes"
      "cgroups"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";
}
