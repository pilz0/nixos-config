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
    deployment.targetHost = "tor2.ams1.as214958.net";
    lxc.enable = true;
    lxc.ctID = "108";
  };

  networking = {
    hostName = "tor2";
    hostId = "2166b432";
  };

  services.tor = {
    settings = {
      address = "94.142.241.153";
      ORPort = 587;
    };
  };

  systemd.network.networks = {
    "10-eth0".address = [
      "2a0e:8f02:f017::10/48"
    ];
    "20-eth1".address = [
      "10.0.0.3/24"
    ];
  };
}
