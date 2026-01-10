{
  lib,
  config,
  ...
}:
with lib;

let
  cfg = config.pilz.lxc;
in
{
  options.pilz.lxc = {
    enable = mkEnableOption "Enable the PVE-LXC module";
    ctID = mkOption {
      type = lib.types.str;
      description = ''
        The PVE CT ID.
      '';
      example = "fe80::715";
    };
  };

  config = mkIf cfg.enable {

    boot.initrd.availableKernelModules = [
      "xhci_pci"
      "nvme"
      "ahci"
    ];
    boot.kernelModules = [ "kvm-amd" ];

    fileSystems."/" = {
      device = "rpool/data/subvol-${cfg.ctID}-disk-0";
      fsType = "zfs";
    };

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}
