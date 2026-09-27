{
  lib,
  ...
}:
{
  imports = [
    ../../profiles/builder
    ../../profiles/vm
    ./hardware-configuration.nix
    ./dns.nix
  ];

  pilz = {
    deployment = {
      targetHost = "89.168.97.129";
      tags = [ "infra" ];
    };
  };

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
    hostName = "build-aarch64";
    hostId = "13243e34";
  };

  networking.firewall = {
    allowPing = true;
    allowedTCPPorts = lib.mkAfter [
      22
      80
      443
      8443
    ];
  };
  system.stateVersion = "23.11";
}
