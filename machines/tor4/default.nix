{
  config,

  ...
}:
{
  imports = [
    ../../modules/container
    ../../modules/services/tor-relay
    ../../modules/services/tor-relay/network-pve.nix
    ../../lib/lxc
    ../../modules/common
  ];

  pilz = {
    deployment.targetHost = "tor4.ams1.as214958.net";
    lxc.enable = true;
    lxc.ctID = "110";
    networking.tor-relay = {
      eth0.address = "2a0e:8f02:f017::12/48";
      eth1.address = "10.0.0.5/24";
    };
    services.tor-relay = {
      enable = true;
      address = "94.142.241.153";
      nickname = "as214958tor4";
      orPort = 80;
    };
  };

  networking = {
    hostName = "tor4";
    hostId = "2166b434";
  };
}
