{
  ...
}:
{
  imports = [
    ../../modules/container
    ../../modules/services/tor-relay
    ../../modules/services/tor-relay/network-pve.nix
    ../../lib/lxc
  ];

  pilz = {
    deployment.targetHost = "tor7.ams1.as214958.net";
    lxc.enable = true;
    lxc.ctID = "113";
  };

  networking = {
    hostName = "tor7";
    hostId = "2166b437";
  };

  services.tor = {
    settings = {
      address = "94.142.241.153";
      ORPort = 23;
    };
  };

  systemd.network.networks = {
    "10-eth0".address = [
      "2a0e:8f02:f017::15/48"
    ];
    "20-eth1".address = [
      "10.0.0.8/24"
    ];
  };
}
