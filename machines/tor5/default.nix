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
    deployment.targetHost = "tor5.ams1.as214958.net";
    lxc.enable = true;
    lxc.ctID = "111";
  };

  networking = {
    hostName = "tor5";
    hostId = "2166b435";
  };

  services.tor = {
    settings = {
      address = "94.142.241.153";
      ORPort = 3389;
    };
  };

  systemd.network.networks = {
    "10-eth0".address = [
      "2a0e:8f02:f017::13/48"
    ];
    "20-eth1".address = [
      "10.0.0.6/24"
    ];
  };
}
