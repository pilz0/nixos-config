{
  config,
  ...
}:
{
  imports = [
    ../../profiles/tor-relay-pve
  ];

  pilz = {
    deployment.targetHost = "tor8.ams1.as214958.net";
    lxc.enable = true;
    lxc.ctID = "114";
    networking.tor-relay = {
      enable = true;
      eth0.address = [ "2a0e:8f02:f017::16/64" ];
      eth1.address = [ "10.0.0.10/24" ];
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
