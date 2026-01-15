{
  pkgs,
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
      example = "102";
    };
  };

  config = mkIf cfg.enable {

    networking.fqdn = "${toString config.networking.hostName}.${toString config.networking.domain}";

    services.fstrim.enable = false;

    systemd.suppressedSystemUnits = [
      "dev-mqueue.mount"
      "sys-kernel-debug.mount"
      "sys-fs-fuse-connections.mount"
      "zfs-zed.service"
      "zfs-share.service"
      "zfs-mount.service"
    ];

    networking = {
      useNetworkd = true;
      domain = "ams1.as214958.net";
      useHostResolvConf = false;
      nameservers = lib.mkAfter [
        "2606:4700:4700::1111"
        "1.1.1.1"
        "2606:4700:4700::1001"
        "1.0.0.1"
      ];

      firewall = {
        allowedTCPPorts = [ 22 ];
        extraCommands = ''
          ${pkgs.iptables}/bin/ip6tables -A INPUT -p tcp --dport 9100 -s 2a0e:8f02:f017::3 -j ACCEPT
        '';
      };
      extraHosts = ''
        ::1 ${config.networking.fqdn}
        ::1 ${config.networking.hostName}
      '';
    };
    boot = {
      isContainer = true;
      kernel.sysctl = {
        "net.ipv6.conf.eth0.accept_dad" = false;
        "net.ipv6.conf.eth0.dad_transmits" = false;
        "net.ipv6.conf.default.accept_dad" = false;
        "net.ipv6.conf.default.dad_transmits" = false;
      };
      loader.grub = {
        efiSupport = true;
        efiInstallAsRemovable = true;
      };
      growPartition = true;
      tmp.useTmpfs = lib.mkDefault true;
    };

    system.stateVersion = "23.11"; # Did you read the comment?

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
