{ config, lib, ... }:

{
  systemd.network = {
    netdevs = {
      "april_dn42" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "april_dn42";
          MTUBytes = "1420";
        };
        wireguardConfig = {
          PrivateKeyFile = config.age.secrets.wg.path;
          ListenPort = 420;
        };
        wireguardPeers = [
          {
            PublicKey = "ZOuvH1ZzCxZR+MHCAGkLdZCkO3/tF0hbHTdI7NNzVik=";
            AllowedIPs = [
              "::/0"
              "0.0.0.0/0"
            ];
            PersistentKeepalive = 25;
          }
        ];
      };
    };
    networks.april_dn42 = {
      matchConfig.Name = "april_dn42";
      address = [ "fe80::1312/64" ];
      routes = [
        {
          Destination = "fe80::1442:1/64";
          Scope = "link";
        }
      ];
      networkConfig = {
        IPv4Forwarding = true;
        IPv6Forwarding = true;
      };
    };
  };

  services.bird2 = {
    config = lib.mkAfter ''
      protocol bgp as_aprl from dnpeers {
          neighbor fe80::1442:1%april_dn42 as 4242422593;
      }
    '';
  };
}
