{
  config,
  ...
}:
{
  networking.networkmanager.enable = true;
  networking.nameservers = [
    "2606:4700:4700::1111"
    "2606:4700:4700::1001"
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
    interfaces.ens19 = {
      ipv6 = {
        addresses = [
          {
            address = "2a0c:b641:701:0:a5:21:4958:1";
            prefixLength = 128;
          }
        ];
        routes = [
          {
            address = "2a0c:b641:701::a5:20:2409:2";
            prefixLength = 128;
            via = "2a0c:b641:701:0:a5:21:4958:1";
          }
          {
            address = "2a0c:b641:701::a5:20:2409:1";
            prefixLength = 128;
            via = "2a0c:b641:701:0:a5:21:4958:1";
          }
        ];
      };
    };
    defaultGateway6 = {
      address = "2a0c:b640:10::2:ffff";
      interface = "ens18";
    };
  };

  networking.extraHosts = ''
    ::1 dus1
  '';
  networking.firewall = {
    allowedTCPPorts = [
      22 # ssh
      53 # DNS
      80 # http
      443 # https
      179 # bgp
      config.services.prometheus.exporters.bird.port
      config.services.prometheus.exporters.wireguard.port
      config.services.prometheus.exporters.smokeping.port
      config.services.prometheus.exporters.node.port
    ];
    allowedUDPPorts = [
      22 # ssh
      53 # DNS
      80 # http
      443 # https
      179 # bgp
      51820 # wireguard
      config.services.prometheus.exporters.bird.port
      config.services.prometheus.exporters.wireguard.port
      config.services.prometheus.exporters.smokeping.port
      config.services.prometheus.exporters.node.port
    ];
  };
}
