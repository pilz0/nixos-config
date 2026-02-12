{
  config,
  ...
}:
{
  age.secrets.wg-key-ams1-dn42 = {
    file = ../../secrets/wg-key-ams1-dn42.age;
    mode = "640";
    owner = "systemd-network";
    group = "systemd-network";
  };

  networking.nat = {
    enable = true;
    externalInterface = "eth0";
    internalInterfaces = [ "wg0" ];
  };

  boot.kernel.sysctl = {
    "net.ipv6.conf.all.proxy_ndp" = 1;
    "net.ipv6.conf.default.proxy_ndp" = 1;
  };

  services.ndppd = {
    enable = true;
    proxies = {
      "eth0".rules = {
        "2a0e:8f02:f017::18/128" = {
          method = "static";
          interface = "wg0";
        };
      };
    };
  };

  networking.firewall.allowedUDPPorts = [ 51820 ];
  networking.firewall.trustedInterfaces = [ "wg0" ];
  networking.useNetworkd = true;

  systemd.network = {
    enable = true;
    networks."50-wg0" = {
      matchConfig.Name = "wg0";
      address = [
        "2a0e:8f02:f017::17/128"
        "10.100.0.1/24"
      ];
      networkConfig = {
        IPv4Forwarding = true;
        IPv6Forwarding = true;
        IPv4ReversePathFilter = "no";
        IPv6AcceptRA = "no";
        IPv6ProxyNDP = true;
        DHCP = false;
      };
      linkConfig = {
        RequiredForOnline = false;
      };
    };
    netdevs."50-wg0" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg0";
        MTUBytes = "1350";
      };
      wireguardConfig = {
        ListenPort = 51820;
        PrivateKeyFile = config.age.secrets.wg-key-ams1-dn42.path;
        RouteTable = "main";
        FirewallMark = 42;
      };
      wireguardPeers = [
        {
          PublicKey = "MvTGDJYlXmFJWS7rUYu9k+r22ScMyPMn933+7zeOUnU=";
          AllowedIPs = [
            "2a0e:8f02:f017::18/128"
            "10.100.0.2/32"
          ];
          PersistentKeepalive = 25;
        }
      ];
    };
  };
}
