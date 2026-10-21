{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.framework-12th-gen-intel
    inputs.catppuccin.nixosModules.catppuccin
    ./hardware-configuration-framwok.nix
    ./framwok-pkgs.nix
    ./graphics.nix
    ./users.nix
    ./restic.nix
    ./network.nix
    ./android-studio.nix
    ./btop.nix
    #   ./no-standby.nix
  ];

  pilz = {
    deployment = {
      targetHost = null;
      allowLocalDeployment = true;
    };
    common.enable = true;
    audio.enable = true;
    shell.enable = true;
    services.ssh.enable = true;
    services.nixosBuilderClient.enable = true;
  };

  security.sudo.wheelNeedsPassword = false;

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  services = {
    # yubikey stuff
    pcscd.enable = true;
    udev.packages = with pkgs; [
      ledger-udev-rules
      trezor-udev-rules
      yubikey-personalization
    ];
    fwupd.enable = true;
  };

  virtualisation = {
    docker.enable = true;
    containerd.enable = true;
  };

  console.keyMap = "de";
  security.rtkit.enable = true;
  i18n.defaultLocale = "de_DE.UTF-8";

  i18n.extraLocaleSettings = {
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
  time.timeZone = "Europe/Berlin";

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  system.stateVersion = "23.11";
}
