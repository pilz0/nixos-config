{
  pkgs,
  ...
}:
{
  # You can import other NixOS modules here
  imports = [
    ./hardware-configuration-framwok.nix
    ./framwok-pkgs.nix
    ./graphics.nix
    ./users.nix
    ./restic.nix
    ./audio.nix
    ./network.nix
    ../../modules/ssh
    ../../modules/shell
    ../../modules/common
    ../../modules/common/pkgs
    ../../modules/nixos-builder-client
    ./android-studio.nix
    #   ./no-standby.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  # yubikey stuff
  services.pcscd.enable = true;
  services.udev.packages = with pkgs; [
    ledger-udev-rules
    trezor-udev-rules
    yubikey-personalization
  ];

  virtualisation.docker.enable = true;
  virtualisation.containerd.enable = true;

  console.keyMap = "de";
  services.printing.enable = true;
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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.extraOptions = ''
    extra-substituters = https://devenv.cachix.org
    extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
  '';
  system.stateVersion = "23.11";
}
