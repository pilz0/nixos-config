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

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024; # 16 GiB
    }
  ];

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
      configureCuda = false;
      carrierBoard = "devkit";
      modesetting.enable = false;
    };
  };

  users.groups.debug = { };

  programs.dconf.enable = true;
}
