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
    services.tor = {
      enable = true;
      address = "94.142.241.153";
      nickname = "as214958tor6";
      orPort = 110;
    };
  };

  networking = {
    hostName = "tor6";
    hostId = "2166b435";
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
