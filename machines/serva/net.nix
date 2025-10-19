{
  ...
}:
{
  networking.networkmanager.enable = true;
  networking.nameservers = [
    "fd42:d42:d42:54::1"
    "172.20.0.53"
    "2606:4700:4700::1111"
    "1.1.1.1"
  ];
  networking.hostName = "serva";
  networking.extraHosts = ''
    127.0.0.1 cloud.ketamin.trade
    172.22.179.129 serva.lg.ketamin.trade
    127.0.0.1 cloud.pilz.foo
    172.22.179.129 serva.lg.pilz.foo
  '';

  networking.useNetworkd = true;

  networking.firewall = {
    allowedTCPPorts = [
      22 # ssh
      53 # DNS
      80 # http
      443 # https
      179 # bgp
      1100 # nextcloud-docker
    ];
    allowedUDPPorts = [
      22 # ssh
      53 # DNS
      1100 # nextcloud-docker
      51820 # wireguard
    ];
  };
}
