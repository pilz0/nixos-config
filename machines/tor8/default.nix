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
    deployment.targetHost = "tor8.ams1.as214958.net";
    lxc.enable = true;
    lxc.ctID = "114";
    networking.tor-relay = {
      eth0.address = "2a0e:8f02:f017::16/48";
      eth1.address = "10.0.0.10/24";
    };
    services.tor-relay = {
      enable = true;
      address = "94.142.241.153";
      nickname = "as214958tor8";
      orPort = 3306;
    };
  };

  networking = {
    hostName = "tor8";
    hostId = "2112e232";
  };
}
