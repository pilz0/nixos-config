{ config, lib, ... }:
let

  pupkey = "";
  tunnelipsubnet = "fe80::21:4958/64";
  name = "ffdaDN42";
  ASN = "4242421403";
  peertunnelip = "fe80::6766";
  ListenPort = "";
  wgendpoint = "";
  role = "peer";
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
          local role ${toString role};
      }
    '';
  };
}
