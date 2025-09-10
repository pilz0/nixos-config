{
  config,
  ...
}:
{
  age.secrets.wg-dus1 = {
    file = ../../secrets/wg-dus1.age;
    owner = "systemd-network";
    group = "systemd-network";
  };

  networking.firewall = {
    trustedInterfaces = [ "wgframwok" ];
    allowedUDPPorts = [ 51821 ];
  };

  systemd.network = {
    netdevs = {
      "70-wgframwok" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wgframwok";
          MTUBytes = "1300";
        };
        wireguardConfig = {
          PrivateKeyFile = config.age.secrets.wg-dus1.path;
          ListenPort = 51821;
        };
        wireguardPeers = [
          {
            PublicKey = "NxHkdwZPVL+3HdrHTFOslUpUckTf0dzEG9qpZ0FTBnA=";
            AllowedIPs = [
              "2a0e:8f02:f017:3::1338/64"
            ];
            PersistentKeepalive = 25;
          }
        ];
      };
    };
    networks."wgframwok" = {
      matchConfig.Name = "wgframwok";
      address = [ "2a0e:8f02:f017:2::1337/64" ];
      routes = [
        {
          Destination = "2a0e:8f02:f017:3::1338/64";
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
}
