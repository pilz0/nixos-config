{
  config,
  ...
}:
{
  networking = {
    hostName = "tor8";
    hostId = "2112e232";
  };

  systemd.network = {
    networks = {
      "10-eth0" = {
        address = [
          "2a0e:8f02:f017::16/48"
        ];
      };
      "20-eth1" = {
        address = [
          "10.0.0.10/24"
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
