{
  lib,
  config,
  ...
}:
{
  age.secrets.wg-dus1 = {
    file = ../secrets/wg-dus1.age;
    owner = "systemd-network";
    group = "systemd-network";
  };

  networking.firewall = {
    trustedInterfaces = [ "wgserva" ];
  };

  systemd.network = {
    netdevs = {
      "wgserva" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wgserva";
          MTUBytes = "1420";
        };
        wireguardConfig = {
          PrivateKeyFile = config.age.secrets.wg-dus1.path;
          ListenPort = 51820;
        };
        wireguardPeers = [
          {
            PublicKey = "NxHkdwZPVL+3HdrHTFOslUpUckTf0dzEG9qpZ0FTBnA=";
            AllowedIPs = [
              "::/0"
            ];
          }
        ];
      };
    };
    networks."wgserva" = {
      matchConfig.Name = "wgserva";
      address = [ "2a0e:8f02:f017:2::1337/128" ];
      routes = [
        {
          Destination = "2a0e:8f02:f017:2::1338/128";
          Scope = "link";
        }
      ];
      networkConfig = {
        IPv6Forwarding = true;
        IPv6AcceptRA = false;
        DHCP = false;
      };

      linkConfig = {
        RequiredForOnline = "no";
      };
    };
  };

  services.bird = {
    config = lib.mkOrder 20 ''
      protocol bgp wgserva from ibgp {
          neighbor 2a0e:8f02:f017:2::1338 as 214958;
      }
    '';
  };
}
