{
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
    deployment.targetHost = "tor3.ams1.as214958.net";
    lxc.enable = true;
    lxc.ctID = "109";
  };

  networking = {
    hostName = "tor3";
    hostId = "2166b432";
  };

  services.tor = {
    settings = {
      address = "94.142.241.153";
      ORPort = 143;
    };
  };

  systemd.network.networks = {
    "10-eth0".address = [
      "2a0e:8f02:f017::11/48"
    ];
    "20-eth1".address = [
      "10.0.0.4/24"
    ];
  };
}
