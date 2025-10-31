{
  config,
  ...
}:
{
  networking = {
    hostName = "tor6";
    hostId = "2166b436";
  };

  systemd.network = {
    networks = {
      "10-eth0" = {
        address = [
          "2a0e:8f02:f017::14/48"
        ];
      };
      "20-eth1" = {
        address = [
          "10.0.0.7/24"
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
