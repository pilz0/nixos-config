{
  ...
}:
{
  networking.networkmanager.enable = true;
  networking.nameservers = [
    "fd42:d42:d42:54::1"
    "2606:4700:4700::1111"
    "1.1.1.1"
  ];
  networking.hostName = "dus1";
  networking.useNetworkd = true;

  networking.enableIPv6 = true;
  networking = {
    interfaces.ens18 = {
      ipv6.addresses = [
        {
          address = "2a0c:b640:10::2:44";
          prefixLength = 112;
        }
      ];
    };
    defaultGateway6 = {
      address = "2a0c:b640:10::2:ffff";
      interface = "ens18";
    };
  };

  networking.firewall = {
    allowedTCPPorts = [
      22 # ssh
      53 # DNS
      80 # http
      443 # https
      179 # bgp
    ];
    allowedUDPPorts = [
      22 # ssh
      53 # DNS
      80 # http
      443 # https
      179 # bgp
      51820 # wireguard
    ];
  };
}
