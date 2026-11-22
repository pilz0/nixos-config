{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ../../profiles/vm
    inputs.disko.nixosModules.disko
    inputs.anodyne-flake.nixosModules.default
  ];

  pilz = {
    deployment = {
      targetHost = "45.150.123.25";
    #   tags = [ "infra" ];
    };
  };

  anodyne-wiki = {
    enable = true;
    api.enable = true;
    chrp.enable = true;
    pkgs.enable = true;
    frontend.enable = true;
    #replicator-secondary = {
      #enable = true;
    #  primaryKey = "";
    #};
    caddy = {
      enable = true;
      domain = "anodyne-nix.as214958.net";
      contactEmail = "acme@pilz.foo";
    };
  };
  system.stateVersion = "23.11";

  networking = {
    hostName = "anodyne-secondary";
  };

  systemd.network = {
    enable = true;
    networks = {
      "10-eth0" = {
        networkConfig = {
          IPv6AcceptRA = false;
        };
        matchConfig.Name = "eth0";
        address = [
          "45.150.123.25/32"
          "2a0f:be01:0:100::115/128"
        ];
        routes = [
          {
            Gateway = "169.254.1.1";
            Destination = "0.0.0.0/0";
            GatewayOnLink = true;
          }
          {
            Gateway = "fe80::1";
            Destination = "::/0";
            GatewayOnLink = true;
          }
        ];
        linkConfig.RequiredForOnline = "routable";
      };
    };
    config = {
      networkConfig = {
        # https://github.com/systemd/systemd/issues/36347
        ManageForeignRoutes = false;
        ManageForeignRoutingPolicyRules = false;
        IPv4Forwarding = false;
        IPv6Forwarding = false;
      };
    };
    wait-online = {
      enable = false;
      anyInterface = false;
    };
  };

  networking = {
    domain = "dus1.as214958.net";
    firewall = {
      allowedTCPPorts = [
        80
        443
      ];
      allowedUDPPorts = [
      ];
    };
  };

  fileSystems."/".device = lib.mkForce "/dev/pool/root";
  fileSystems."/boot".device = lib.mkForce "/dev/disk/by-partlabel/disk-disk1-ESP";

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
