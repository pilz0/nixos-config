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
    #"${modulesPath}/virtualisation/oci-image.nix"
    inputs.disko.nixosModules.disko
    ./disk-config.nix
  ];

  pilz = {
    deployment = {
      targetHost = "build-aarch64-2.as214958.net";
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
        "10.0.0.247/24"
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
    hostName = "build-aarch64-2";
    hostId = "13243e34";
  };

  networking.firewall = {
    allowPing = true;
    allowedTCPPorts = lib.mkAfter [
      22
    ];
  };
  system.stateVersion = "23.11";
}
