{ config, lib, ... }:

{
  systemd.network = {
    netdevs = {
      "0x4a6f_dn42" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "0x4a6f_dn42";
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
            Endpoint = "dn42.vpn02.ernst.is:51832";
            PersistentKeepalive = 20;
          }
        ];
      };
    };
    networks."0x4a6f_dn42" = {
      matchConfig.Name = "0x4a6f_dn42";
      address = [ "fe80::1312/64" ];
      routes = [
        {
          Destination = "fe80::1312/64";
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
      protocol bgp 0x4a6f_dn42 from dnpeers {
          neighbor fe80::1442:1%0x4a6f as 4242420064;
      }
    '';
  };
}
