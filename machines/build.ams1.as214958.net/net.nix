{
  ...
}:
{
  networking = {
    hostName = "build";
    hostId = "12163e34";
  };

  systemd.network = {
    networks = {
      "10-eth0" = {
        address = [
          "10.10.10.8/24"
          "2a0e:8f02:f017::8/48"
        ];
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [
      80
      443
    ];
    allowedUDPPorts = [
    ];
  };
}
