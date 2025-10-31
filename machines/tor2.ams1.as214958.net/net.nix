{
  config,
  ...
}:
{
  networking = {
    hostName = "tor2";
    hostId = "2166b432";
  };

  systemd.network = {
    networks = {
      "10-eth0" = {
        address = [
          "2a0e:8f02:f017::10/48"
        ];
      };
      "20-eth1" = {
        address = [
          "10.0.0.3/24"
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
