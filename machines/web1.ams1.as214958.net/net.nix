{
  ...
}:
{
  networking = {
    hostName = "web1";
    hostId = "4066b435";
  };
  systemd.network = {
    enable = true;
    networks = {
      "10-eth0" = {
        address = [
          "94.142.241.152/31"
          "2a0e:8f02:f017::2/48"
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
