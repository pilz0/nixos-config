{ config, lib, ... }:
let

  pupkey = "MJd3RQEM6+uFx1376rpIC99XWanD9e3iE3aFS2wa9TI=";
  tunnelipsubnet = "fe80::acab/64";
  name = "NOT_MNT";
  ASN = "4242420020";
  peertunnelip = "fe80::d311";
  ListenPort = "20";
  wgendpoint = "v4.dn42.iputils.de:20663";
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

  networking.firewall = {
    allowedUDPPorts = [
      20 # peering with not_mnt
    ];
  };
}
