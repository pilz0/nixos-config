{
  config,
  ...
}:
{
  networking = {
    hostName = "tor5";
    hostId = "2166b435";
  };

  systemd.network = {
    networks = {
      "10-eth0" = {
        address = [
          "2a0e:8f02:f017::13/48"
        ];
      };
      "20-eth1" = {
        address = [
          "10.0.0.6/24"
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
