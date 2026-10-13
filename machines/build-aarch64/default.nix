{
  lib,
  modulesPath,
  inputs,
  ...
}:
{
  imports = [
    ../../profiles/builder
    ../../profiles/oracle
    ./hardware-configuration.nix
    ./dns.nix
    #"${modulesPath}/virtualisation/oci-image.nix"
    inputs.disko.nixosModules.disko
    ./disk-config.nix
  ];

  pilz = {
    deployment = {
      targetHost = "build-aarch64.as214958.net";
      tags = [ "infra" ];
    };
  };

  systemd.network.networks = {
    "10-eth0" = {
      networkConfig = {
        IPv6AcceptRA = true;
      };
      matchConfig.Name = "eth0";
      linkConfig.RequiredForOnline = "routable";
      address = [
        "10.0.0.15/24"
        "2603:c020:8028:ce67:0:995d:ae04:7a9a/128"
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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = lib.mkAfter [ "net.ifnames=0" ];

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
