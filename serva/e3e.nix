{ config, lib, ... }:
let
  pupkey = "Q3btSOBu8ClwQjdned5muBP/DEvK9Wb7cUfbkh2mjTQ=";
  tunnelip = "fe80::acab/64";
  name = "e3e";
  ASN = "4242421111";
  wgendpoint = "85.215.209.127:20663";
  peertunnelip = "fe80::1312/64";
in
{

  systemd.network = {
    netdevs = {
      "${toString name}" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = name;
          MTUBytes = "1420";
        };
        wireguardConfig = {
          PrivateKeyFile = config.age.secrets.wg.path;
        };
        wireguardPeers = [
          {
            PublicKey = pupkey;
            AllowedIPs = [
              "::/0"
              "0.0.0.0/0"
            ];
            Endpoint = toString wgendpoint;
            PersistentKeepalive = 25;
          }
        ];
      };
    };
    networks."${toString name}" = {
      matchConfig.Name = name;
      address = [ tunnelip ];
      routes = [
        {
          Destination = peertunnelip;
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
      protocol bgp ${toString name} from dnpeers {
          neighbor ${toString peertunnelip}%${toString name} as ${toString ASN};
      }
    '';
  };
}
