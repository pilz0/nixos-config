{
  config,
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
  services.unpoller = {
    #   enable = true;
    influxdb.disable = true;
    unifi = {
      defaults = {
        url = "https://localhost:8443";
        user = "unpoller";
        pass = "/srv/password";
        verify_ssl = false;
      };
    };
  };

  networking.useNetworkd = true;
  #  systemd.network = {
  #    enable = true;
  #    netdevs = {
  #      "50-wg-cybertrash" = {
  #        netdevConfig = {
  #          Kind = "wireguard";
  #          Name = "wg-cybertrash";
  #          MTUBytes = "1300";
  #        };
  #        wireguardConfig = {
  #          PrivateKeyFile = config.age.secrets.wg.path;
  #          ListenPort = 51820;
  #        };
  #        wireguardPeers = [
  #          {
  #            ## Laptop
  #            PublicKey = "ufN4BlaAZZUXGcRDDQfDX7n0toGVzstjlF22nbHMT1E=";
  #            AllowedIPs = [
  #              "172.22.179.146"
  #              "fd49:d69f:6:100::69/64"
  #            ];
  #          }
  #        ];
  #      };
  #    };
  #    networks.wg-cybertrash = {
  #      matchConfig.Name = "wg-cybertrash";
  #      address = [
  #        "172.22.179.144/28"
  #        "fd49:d69f:6:100::/56"
  #      ];
  #      networkConfig = {
  #        IPv4Forwarding = true;
  #        IPv6Forwarding = true;
  #      };
  #    };
  #  };

  networking.firewall = {
    trustedInterfaces = [ "dus1" ];
    allowedTCPPorts = [
      22 # ssh
      53 # DNS
      80 # http
      443 # https
      179 # bgp
      420 # Peering with April
      1100 # nextcloud-docker
      9001 # routerlab
      9002 # routerlab
      9003 # routerlab
      9004 # routerlab
      9005 # routerlab
      6901 # linuxvm
      6902 # linuxvm
      6903 # linuxvm
      6904 # linuxvm
    ];
    allowedUDPPorts = [
      22 # ssh
      53 # DNS
      80 # http
      443 # https
      179 # bgp
      420 # Peering with April
      1100 # nextcloud-docker
      9001 # routerlab
      9002 # routerlab
      9003 # routerlab
      9004 # routerlab
      9005 # routerlab
      6901 # linuxvm
      6902 # linuxvm
      6903 # linuxvm
      6904 # linuxvm
      51820 # wireguard
    ];
  };
}
