{
  config,
  ...
}:
{
  networking = {
    hostName = "tor3";
    hostId = "2166b433";
  };

  systemd.network = {
    networks = {
      "10-eth0" = {
        address = [
          "2a0e:8f02:f017::11/48"
        ];
      };
      "20-eth1" = {
        address = [
          "10.0.0.4/24"
        ];
      };

    };
  };

  networking.firewall = {
    allowedTCPPorts = [
      config.services.tor.settings.ORPort
    ];
    allowedUDPPorts = [
      config.services.tor.settings.ORPort
    ];
  };
}
