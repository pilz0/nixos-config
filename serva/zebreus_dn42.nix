{ config, lib, ... }:

{
  systemd.network = {
    netdevs = {
      "zebreus_dn42" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "zebreus_dn42";
          MTUBytes = "1420";
        };
        wireguardConfig = {
          PrivateKeyFile = config.age.secrets.wg.path;
        };
        wireguardPeers = [
          {
            PublicKey = "4UTrN0YlflDPRhH9ak5nwrZrL0IrJiZUkEUiSuboRUc=";
            AllowedIPs = [
              "::/0"
              "0.0.0.0/0"
            ];
            Endpoint = "pogopeering.dn42.antibuild.ing:1";
            PersistentKeepalive = 25;
          }
        ];
      };
    };
    networks.zebreus_dn42 = {
      matchConfig.Name = "zebreus_dn42";
      address = [ "fe80::1312/64" ];
      routes = [
        {
          Destination = "fe80::acab/64";
          Scope = "link";
        }
      ];
      networkConfig = {
        IPv4Forwarding = true;
        IPv6Forwarding = true;
      };
    };
  };

  services.bird = {
    config = lib.mkAfter ''
      protocol bgp antibuilding from dnpeers {
          neighbor fe80::acab%zebreus_dn42 as 4242421403;
      }
    '';
  };
}
