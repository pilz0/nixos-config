{ config, lib, ... }:

{
  systemd.network = {
    netdevs = {
      "iedon_dn42" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "iedon_dn42";
          MTUBytes = "1420";
        };
        wireguardConfig = {
          PrivateKeyFile = config.age.secrets.wg.path;
        };
        wireguardPeers = [
          {
            PublicKey = "FHp0OR4UpAS8/Ra0FUNffTk18soUYCa6NcvZdOgxY0k=";
            AllowedIPs = [
              "::/0"
              "0.0.0.0/0"

            ];
            Endpoint = "157.90.129.252:55449";
            PersistentKeepalive = 25;
          }
        ];
      };
    };
    networks.iedon_dn42 = {
      matchConfig.Name = "iedon_dn42";
      address = [ "fe80::2189:e9/64" ];
      routes = [
        {
          Destination = "fe80::2189:e9/64";
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
      protocol bgp iedon_dn42 from dnpeers {
          neighbor fe80::2189:e9%iedon_dn42 as 4242422189;
          local role customer;
      }
    '';
  };
}
