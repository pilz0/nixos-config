{ config, lib, ... }:

{
  systemd.network = {
    netdevs = {
      "ernst_is_dn42" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "ernst_is_dn42";
          MTUBytes = "1420";
        };
        wireguardConfig = {
          PrivateKeyFile = config.age.secrets.wg.path;
        };
        wireguardPeers = [
          {
            PublicKey = "PK8cQ3ghSNYPMurgTPXGXoHkYvqseRZgBa9oGVO+dzM=";
            AllowedIPs = [
              "::/0"
              "0.0.0.0/0"
            ];
            Endpoint = "157.90.129.252:51832";
            PersistentKeepalive = 25;
          }
        ];
      };
    };
    networks."ernst_is_dn42" = {
      matchConfig.Name = "ernst_is_dn42";
      address = [ "fe80::acab/64" ];
      routes = [
        {
          Destination = "fe80::1312/64";
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
      protocol bgp ernst_is_dn42 from dnpeers {
          neighbor fe80::1312%ernst_is_dn42 as 4242420064;
          local role peer;
      }
    '';
  };
}
