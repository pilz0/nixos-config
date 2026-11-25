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

  # nixpkgs renamed cudaPackages.cuda_cccl to cccl and cuda_nvtx to nvtx,
  # but jetpack-nixos only replaces cuda_cccl and cuda_nvtx with their deb builds,
  # leaving cccl and nvtx unsupported on 11.4
  nixpkgs.overlays = lib.mkAfter [
    # nixpkgs no longer runs a serial `make prepare` before the parallel build
    # (NixOS/nixpkgs@cf4da14a33). The r35 kernel's nvmap overlay gets pulled into
    # the root kbuild dir, so prepare0 compiles nvmap before generated/bounds.h exists.
    (final: prev: {
      nvidia-jetpack = prev.nvidia-jetpack.overrideScope (
        _: prevJetpack: {
          kernel =
            (
              if lib.versionOlder prevJetpack.kernel.version "5.19" then
                # nixpkgs unconditionally applies randstruct-provide-seed-5.19.patch,
                # which patches scripts/gen-randstruct-seed.sh (introduced in Linux 5.19).
                prevJetpack.kernel.override {
                  buildLinux = final.buildLinux.override {
                    callPackage =
                      fn: args:
                      let
                        res = final.callPackage fn args;
                      in
                      if lib.isFunction res then
                        drvArgs:
                        (res drvArgs).overrideAttrs (old: {
                          patches = builtins.filter (
                            p: baseNameOf (toString p) != "randstruct-provide-seed-5.19.patch"
                          ) old.patches;
                        })
                      else
                        res;
                  };
                }
              else
                prevJetpack.kernel
            ).overrideAttrs
              (old: {
                # Modern glibc/linux-headers' aarch64 <asm/sigcontext.h> uses __u128,
                # which Linux 5.10's shadowed tools/include/**/linux/types.h predates.
                postPatch = (old.postPatch or "") + ''
                  for f in tools/include/linux/types.h tools/include/uapi/linux/types.h; do
                    if [ -f "$f" ] && ! grep -q '__u128' "$f"; then
                      printf '%s\n' \
                        '#if defined(__SIZEOF_INT128__) && !defined(_NIX_LINUX_U128_DEFINED)' \
                        '#define _NIX_LINUX_U128_DEFINED' \
                        '__extension__ typedef __signed__ __int128 __s128 __attribute__((aligned(16)));' \
                        '__extension__ typedef unsigned __int128 __u128 __attribute__((aligned(16)));' \
                        '#endif' >> "$f"
                    fi
                  done
                '';
                preBuild = (old.preBuild or "") + ''
                  make "''${makeFlags[@]}" prepare
                '';
              });
        }
      );
    })
    # Packages incompatible with JetPack 5's CUDA 11.4 / GCC 10 toolchain:
    # - onnxruntime 1.27+ requires CUDA >= 12.0 and cuDNN 9, and cuda-legacy's
    #   overlay patch no longer applies on 1.27.1; also skip Intel OpenVINO.
    # - llama-cpp's cpuArchDynamicDispatch compiles -march=armv9.2-a, which GCC 10 rejects.
    (final: prev: {
      onnxruntime =
        if final.cudaPackages.cudaOlder "12.0" then
          final.callPackage "${final.path}/pkgs/by-name/on/onnxruntime/package.nix" {
            cudaSupport = false;
            openvinoSupport = false;
          }
        else
          prev.onnxruntime;
      llama-cpp =
        if final.cudaPackages.cudaOlder "12.0" then
          prev.llama-cpp.override {
            cpuArchDynamicDispatch = false;
          }
        else
          prev.llama-cpp;
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
              nvtx =
                if prevCudaPkgs.cudaMajorMinorVersion == "11.4" then
                  finalCuda.debWrapBuildRedist {
                    sourceName = "cuda-nvtx";
                    drv = prevCudaPkgs.nvtx;
                  }
                else
                  prevCudaPkgs.nvtx;
              cuda_nvtx = finalCuda.nvtx;
            })
          ];
        }
      );
    })
  ];

  users.groups.debug = { };

  programs.dconf.enable = true;
}
