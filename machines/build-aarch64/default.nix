{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ../../profiles/importAll
    inputs.disko.nixosModules.disko
    inputs.determinate.nixosModules.default
    ../../profiles/builder
    ./hardware-configuration.nix
    ./disk-config.nix
    ./dns.nix
  ];

  pilz = {
    services.ssh.enable = true;
    shell.enable = true;
    monitoring.node-exporter.enable = true;
    common.enable = true;
    deployment = {
      targetHost = "89.168.97.129";
      tags = [ "infra" ];
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "net.ifnames=0" ];

  systemd.network.networks = {
    "10-eth0" = {
      networkConfig = {
        IPv6AcceptRA = true;
      };
      matchConfig.Name = "eth0";
      linkConfig.RequiredForOnline = "routable";
      address = [
        "10.0.0.45/24"
      ];
      routes = [
        {
          Gateway = "10.0.0.1";
          Destination = "0.0.0.0/0";
          GatewayOnLink = true;
        }
      ];
    };
  };
  networking.useDHCP = false;

  nix.settings = {
    max-jobs = 4;
    cores = 4;
  };

  security.sudo = {
    enable = true;
    execWheelOnly = true;
    wheelNeedsPassword = false;
  };

  networking = {
    useNetworkd = true;
    nameservers = lib.mkAfter [
      "2606:4700:4700::1111"
      "1.1.1.1"
      "2606:4700:4700::1001"
      "1.0.0.1"
    ];
  };

  networking = {
    hostName = "build-aarch64";
    hostId = "13243e34";
  };

  networking.firewall = {
    allowPing = true;
    allowedTCPPorts = [
      22
      80
      443
    ];
    allowedUDPPorts = [
    ];
  };
  system.stateVersion = "23.11";
}
