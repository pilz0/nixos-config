{ config, lib, ... }:
{
  # WG to dus1.as214958.net
  systemd.network = {
    netdevs = {
      "dus1" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "dus1";
          MTUBytes = "1420";
        };
        wireguardConfig = {
          PrivateKeyFile = config.age.secrets.wg.path;
        };
        wireguardPeers = [
          {
            PublicKey = "rGhXFZSj5KgQmudouZ4LRZnBBjv/0U1wcHcZiwgGeng=";
            AllowedIPs = [
              "::/0"
              "0.0.0.0/0"
            ];
            Endpoint = "dus1.as214958.net:51820";
            PersistentKeepalive = 25;
          }
        ];
      };
    };
    networks."dus1" = {
      matchConfig.Name = "dus1";
      address = [ "2a0e:8f02:f017:2::1338/128" ];
      routes = [
        {
          Destination = "2a0e:8f02:f017:2::1337/128";
          Scope = "link";
        }
      ];
      networkConfig = {
        IPv4Forwarding = true;
        IPv6Forwarding = true;
        IPv4ReversePathFilter = "no";
        IPv6AcceptRA = false;
        DHCP = false;
      };

      linkConfig = {
        RequiredForOnline = "no";
      };
    };
  };
  services.bird = {
    config = lib.mkAfter ''
        protocol bgp dus1 {
          path metric 1;
          local as 214958;
          enable extended messages on;
          graceful restart on;
          long lived graceful restart on;
          ipv4 {
            import none;
            export none;
          };
          ipv6 {
            import all;
            export none;
          };
          neighbor 2a0e:8f02:f017:2::1337 as 214958;
      }
    '';
  };
}
