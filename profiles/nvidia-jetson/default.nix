{
  config,
  lib,
  pkgs,
  modulesPath,
  inputs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.jetpack.nixosModules.default
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
    };

    initrd = {
      systemd.tpm2.enable = false;
      availableKernelModules = [
        "nvme"
        "ahci"
        "usbhid"
        "usb_storage"
      ];
      kernelModules = [ ];
    };
    kernelModules = [ ];
    extraModulePackages = [ ];
  };

  swapDevices = [ ];
  services.nvpmodel = {
    enable = true;
    profileNumber = 0;
  };

  hardware = {
    graphics.enable = true;
    graphics.enable32Bit = lib.mkForce false;
    nvidia-container-toolkit.enable = true;
    nvidia-jetpack = {
      enable = true;
      configureCuda = true;
      carrierBoard = "devkit";
      modesetting.enable = false;
    };
  };

  # use hdmi port
  # https://github.com/anduril/jetpack-nixos?tab=readme-ov-file#linux-console
  boot.kernelParams = [ "fbcon=map:2" ];

  users.groups.debug = { };

  programs.dconf.enable = true;
}
