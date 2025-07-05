{
  config,
  ...
}:
{
  networking.networkmanager.enable = false; # Disable NetworkManager
  networking.useNetworkd = true;

  services.resolved = {
    enable = true;
    dnssec = "false"; # Disable DNSSEC to reduce CPU usage
    fallbackDns = [
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];
    llmnr = "false";
    extraConfig = ''
      Cache=yes
      CacheFromLocalhost=no
      DNSStubListener=yes
      ReadEtcHosts=yes
      ResolveUnicastSingleLabel=no
      # Reduce timeout and retries to prevent CPU spikes
      DNSDefaultRoute=yes
      MulticastDNS=no
    '';
  };

  networking.hostName = "dus1";

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
      ipv4 = {
        addresses = [
          {
            address = "185.1.155.158";
            prefixLength = 24;
          }
        ];
      };
      ipv6 = {
        addresses = [
          {
            address = "2a0c:b641:701:0:a5:21:4958:1";
            prefixLength = 64;
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

  # Optional: Limit systemd-resolved resource usage
  systemd.services.systemd-resolved.serviceConfig = {
    CPUQuota = "25%"; # Limit CPU usage
    MemoryMax = "64M";
  };
}
