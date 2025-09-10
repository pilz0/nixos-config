{ config, lib, ... }:
let

  pupkey = "B3ZZUvJ/ZG9dc9cl4t4wofD/+wsmm+r56Uh9hqPrZEE=";
  tunnelipsubnet = "fe80::acab/64";
  name = "Katja_DN42";
  ASN = "4242421718";
  peertunnelip = "fe80::6b61";
  ListenPort = "";
  wgendpoint = "router-a.dn42.zaphyra.eu:51833";
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
          ListenPort = ListenPort;
        };
        wireguardPeers = [
          {
            PublicKey = pupkey;
            AllowedIPs = [
              "::/0"
              "0.0.0.0/0"
            ];
            Endpoint = wgendpoint;
            PersistentKeepalive = 25;
          }
        ];
      };
    };
    networks."${toString name}" = {
      matchConfig.Name = name;
      address = [ tunnelipsubnet ];
      routes = [
        {
          Destination = peertunnelip + "/64";
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
      protocol bgp ${toString name} from dnpeers {
          neighbor ${toString peertunnelip}%${toString name} as ${toString ASN};
      }
    '';
  };
}
