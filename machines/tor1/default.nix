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
    deployment.targetHost = "tor1.ams1.as214958.net";
    lxc.enable = true;
    lxc.ctID = "107";
  };

  networking = {
    hostName = "tor1";
    hostId = "2166b431";
  };

  services.tor = {
    settings = {
      address = "94.142.241.153";
      Nickname = "as214958tor1";
      ORPort = 443;
    };
  };

  systemd.network.networks = {
    "10-eth0".address = [
      "2a0e:8f02:f017::9/48"
    ];
    "20-eth1".address = [
      "10.0.0.2/24"
    ];
  };
}
