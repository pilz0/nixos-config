{
  ...
}:
{
  networking = {
    useNetworkd = true;
    hostName = "dn42";
    domain = "as214958.net";
    hostId = "40163434";
  };

  systemd.network = {
    networks = {
      "10-eth0" = {
        address = [
          "10.10.10.6/24"
          "2a0e:8f02:f017::6/48"
        ];
      };
    };
  };

  networking.extraHosts = ''
    ::1 dn42.ams1.as214958.net
    ::1 dn42
  '';

  networking.firewall = {
    allowedTCPPorts = [
      22 # ssh
    ];
    allowedUDPPorts = [
    ];
  };
}
