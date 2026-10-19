{
  inputs,
  modulesPath,
  config,
  lib,
  ...
}:
{
  imports = [
    inputs.determinate.nixosModules.default
    inputs.disko.nixosModules.disko
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  nix.settings = {
    max-jobs = 4;
    cores = 4;
  };

  system.stateVersion = "23.11";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = lib.mkAfter [ "net.ifnames=0" ];

  pilz = {
    shell.enable = true;
    services.ssh.enable = true;
    common.enable = true;
    monitoring.node-exporter.enable = true;
    monitoring.systemd-exporter.enable = true;
  };

  networking = {
    usePredictableInterfaceNames = false;
    useNetworkd = true;
    useDHCP = false;
    domain = "as214958.net";
    nameservers = lib.mkAfter [
      "2606:4700:4700::1111"
      "1.1.1.1"
      "2606:4700:4700::1001"
      "1.0.0.1"
    ];
    firewall = {
      allowPing = true;
      allowedTCPPorts = lib.mkAfter [
        22
        80
        443
        8443
      ];
    };
  };

  systemd.network.networks = {
    "10-eth0" = {
      networkConfig = {
        IPv6AcceptRA = true;
      };
      matchConfig.Name = "eth0";
      linkConfig.RequiredForOnline = "routable";

      routes = [
        {
          Gateway = "10.0.0.1";
          Destination = "0.0.0.0/0";
          GatewayOnLink = true;
        }
      ];
    };
  };
  security.sudo = {
    execWheelOnly = true;
    wheelNeedsPassword = false;
  };

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "virtio_pci"
    "virtio_scsi"
    "usbhid"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
  disko.devices = {
    disk.disk1 = {
      device = lib.mkDefault "/dev/sda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            name = "boot";
            size = "1M";
            type = "EF02";
          };
          esp = {
            name = "ESP";
            size = "500M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          root = {
            name = "root";
            size = "100%";
            content = {
              type = "lvm_pv";
              vg = "pool";
            };
          };
        };
      };
    };
    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "100%FREE";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [
                "defaults"
              ];
            };
          };
        };
      };
    };
  };
}
