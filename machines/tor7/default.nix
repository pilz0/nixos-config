{
  config,

  ...
}:
{
  imports = [
    ../../profiles/tor-relay-pve
  ];

  pilz = {
    deployment.targetHost = "tor7.ams1.as214958.net";
    lxc.enable = true;
    lxc.ctID = "113";
    networking.tor-relay = {
      eth0.address = "2a0e:8f02:f017::15/64";
      eth1.address = "10.0.0.8/24";
    };
    services.tor-relay = {
      enable = true;
      address = "94.142.241.153";
      nickname = "as214958tor7";
      orPort = 23;
    };
  };

  networking = {
    hostName = "tor7";
    hostId = "2166b437";
  };
}
