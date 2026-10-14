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
    ./dns.nix
    inputs.disko.nixosModules.disko
  ];

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 64 * 1024; # 64 GiB
    }
  ];

  pilz = {
    deployment = {
      targetHost = "build-aarch64.as214958.net";
      tags = [ "infra" ];
    };
  };

  systemd.network.networks = {
    "10-eth0" = {
      address = [
        "10.0.0.15/24"
        "2603:c020:8028:ce67:0:995d:ae04:7a9a/128"
      ];
    };
  };

  networking = {
    hostName = "build-aarch64";
    hostId = "13243e34";
  };
}
