{
  inputs,
  ...
}:
{
  imports = [
    inputs.jetpack.nixosModules.default
    inputs.determinate.nixosModules.default
    inputs.vscode-server.nixosModules.default
    ../../modules/ssh
    ../../modules/shell
    ../../modules/common/pkgs
    ../../modules/audio
    ./nvidia.nix
    ./graphics.nix
    ./pkgs.nix
    ./hardware-configuration.nix
  ];

  users.users = {
    snakii = {
      extraGroups = [
        "wheel"
      ];
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA/+iN407+HsfHbbC3tfdA8Yf4TZ08qXQMb4tb/SDAs+"
      ];
    };
  };

  age.secrets.fediToken = {
    file = ../../secrets/fedi-bot-fediToken.age;
  };
  age.secrets.hfToken = {
    file = ../../secrets/fedi-bot-hfToken.age;
  };

  pilz = {
    deployment = {
      targetHost = "192.168.0.225";
    };
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
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
