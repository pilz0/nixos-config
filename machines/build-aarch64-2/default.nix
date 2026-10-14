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
    inputs.disko.nixosModules.disko
  ];

  pilz = {
    deployment = {
      targetHost = "build-aarch64-2.as214958.net";
      tags = [ "infra" ];
    };
  };

  systemd.network.networks = {
    "10-eth0" = {
      address = [
        "10.0.0.247/24"
        "2603:c020:8026:ba67:3244::/80"
      ];
    };
  };

  networking = {
    hostName = "build-aarch64-2";
    hostId = "13243e34";
  };
}
