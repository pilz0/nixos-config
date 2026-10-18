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
      configureCuda = true;
      carrierBoard = "devkit";
      modesetting.enable = false;
    };
  };

  # nixpkgs renamed cudaPackages.cuda_cccl to cccl, but jetpack-nixos only
  # replaces cuda_cccl with its deb build, leaving cccl unsupported on 11.4
  nixpkgs.overlays = lib.mkAfter [
    (final: prev: {
      _cuda = prev._cuda.extend (
        _: prevCuda: {
          extensions = prevCuda.extensions ++ [
            (finalCuda: prevCudaPkgs: {
              cccl =
                if prevCudaPkgs.cudaMajorMinorVersion == "11.4" then
                  finalCuda.debWrapBuildRedist {
                    sourceName = "cuda-thrust";
                    drv = prevCudaPkgs.cccl;
                  }
                else
                  prevCudaPkgs.cccl;
            })
          ];
        }
      );
    })
  ];

  users.groups.debug = { };

  programs.dconf.enable = true;
}
