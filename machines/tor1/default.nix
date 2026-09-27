{
  config,
  ...
}:
{
  imports = [
    ../../profiles/vm
  ];

  pilz = {
    deployment.targetHost = "tor1.ams1.as214958.net";
    networking.tor-relay = {
      enable = true;
      eth0.address = [ "2a0e:8f02:f017::9/64" ];
      eth1.address = [ "10.0.0.2/24" ];
    };
    services.tor-relay = {
      enable = true;
      address = "94.142.241.153";
      nickname = "as214958tor1";
      orPort = 443;
    };
  };

  system.stateVersion = "23.11";

  networking = {
    hostName = "tor1";
    hostId = "2166b431";
  };
}
