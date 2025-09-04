{ config, lib, ... }:
let

  pupkey = "uS1AYe7zTGAP48XeNn0vppNjg7q0hawyh8Y0bvvAWhk=";
  tunnelipsubnet = "fe80::acab/64";
  name = "maraun_dn42";
  ASN = "4242422225";
  peertunnelip = "fe80::2225";
  ListenPort = "";
  wgendpoint = "37.120.175.249:20663";
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
      protocol bgp ${toString name} from dnpeers {
          neighbor ${toString peertunnelip}%${toString name} as ${toString ASN};
      }
    '';
  };
}
