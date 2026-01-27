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
    deployment.targetHost = "tor6.ams1.as214958.net";
    lxc.enable = true;
    lxc.ctID = "112";
  };

  networking = {
    hostName = "tor6";
    hostId = "2166b435";
  };

  services.tor = {
    settings = {
      address = "94.142.241.153";
      Nickname = "as214958tor6";
      ORPort = 110;
    };
  };

  systemd.network.networks = {
    "10-eth0".address = [
      "2a0e:8f02:f017::14/48"
    ];
    "20-eth1".address = [
      "10.0.0.7/24"
    ];
  };
}
