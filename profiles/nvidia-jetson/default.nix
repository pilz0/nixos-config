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
    # nixpkgs no longer runs a serial `make prepare` before the parallel build
    # (NixOS/nixpkgs@cf4da14a33). The r35 kernel's nvmap overlay gets pulled into
    # the root kbuild dir, so prepare0 compiles nvmap before generated/bounds.h exists.
    (final: prev: {
      nvidia-jetpack = prev.nvidia-jetpack.overrideScope (
        _: prevJetpack: {
          kernel = prevJetpack.kernel.overrideAttrs (old: {
            preBuild = (old.preBuild or "") + ''
              make "''${makeFlags[@]}" prepare
            '';
          });
        }
      );
    })
    # gcc10 (from cuda-legacy, used as nvcc host compiler for CUDA 11.4) fails to build
    # libsanitizer against current kernel headers, which dropped linux/scc.h.
    (final: prev: {
      gccVersions = prev.gccVersions // {
        gcc10 = prev.gccVersions.gcc10.override (o: {
          cc = o.cc.overrideAttrs (a: {
            configureFlags = a.configureFlags ++ [ "--disable-libsanitizer" ];
          });
        });
      };
    })
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
