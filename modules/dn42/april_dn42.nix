{ config, lib, ... }:
let
  pupkey = "ZOuvH1ZzCxZR+MHCAGkLdZCkO3/tF0hbHTdI7NNzVik=";
  tunnelipsubnet = "fe80::1312/64";
  name = "april_dn42";
  ASN = "4242422593";
  peertunnelip = "fe80::1442:1";
  ListenPort = "420";
  wgendpoint = "";
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
  networking.firewall = {
    allowedUDPPorts = [
      420 # Peering with April
    ];
  };
}
