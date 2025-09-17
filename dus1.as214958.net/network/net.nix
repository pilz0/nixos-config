{
  ...
}:
{
  imports = [
    ./wgframwok.nix
  ];
  networking = {
    useNetworkd = true;
    hostName = "dus1";
  };

  services.resolved = {
    enable = true;
    dnssec = "false";
    fallbackDns = [
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
      "1.1.1.1"
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

  systemd.network = {
    enable = true;
    networks = {
      "10-ens18" = {
        matchConfig.Name = "ens18";
        address = [
          "2a0c:b640:10::2:44/112"
        ];
        routes = [
          { Gateway = "2a0c:b640:10::2:ffff"; }
        ];
        linkConfig.RequiredForOnline = "routable";
      };
      "20-ens19" = {
        matchConfig.Name = "ens19";
        address = [
          "185.1.155.158/24"
          "2a0c:b641:701:0:a5:21:4958:1/64"
        ];
        linkConfig.RequiredForOnline = "no";
      };
      "30-dummyinter" = {
        matchConfig.Name = "dummyinter";
        address = [
          "2a0e:8f02:f017::1337/64"
        ];
        networkConfig = {
          ConfigureWithoutCarrier = true;
        };
      };

    };
    config = {
      networkConfig = {
        # https://github.com/systemd/systemd/issues/36347
        ManageForeignRoutes = false;
        ManageForeignRoutingPolicyRules = false;
        IPv4Forwarding = true;
        IPv6Forwarding = true;
      };
    };
    wait-online = {
      enable = false;
      anyInterface = false;
    };
    netdevs = {
      "50-dummyinter" = {
        enable = true;
        netdevConfig = {
          Kind = "dummy";
          Name = "dummyinter";
        };
      };
    };
  };

  networking.extraHosts = ''
    ::1 dus1
  '';

  networking.firewall = {
    allowedTCPPorts = [
      22 # ssh
      80 # http
      443 # https
    ];
    allowedUDPPorts = [
      51820 # wireguard
    ];
  };

  systemd.services.systemd-resolved.serviceConfig = {
    CPUQuota = "25%";
    MemoryMax = "64M";
  };
}
