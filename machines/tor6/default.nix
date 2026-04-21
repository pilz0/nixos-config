{
  config,

  ...
}:
{
  imports = [
    ../../profiles/tor-relay-pve
  ];

  pilz = {
    deployment.targetHost = "tor6.ams1.as214958.net";
    lxc.enable = true;
    lxc.ctID = "112";
    networking.tor-relay = {
      eth0.address = "2a0e:8f02:f017::14/48";
      eth1.address = "10.0.0.7/24";
    };
    services.tor-relay = {
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
}
