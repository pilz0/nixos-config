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
  systemd.network = {
    netdevs = {
      "dus1" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "dus1";
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
              "0.0.0.0/0"
            ];
            PersistentKeepalive = 25;
          }
        ];
      };
    };
    networks."wgserva" = {
      matchConfig.Name = "wgserva";
      address = [ "2a0e:8f02:f017:2::1337/64" ];
      routes = [
        {
          Destination = "2a0e:8f02:f017:2::1312/64";
          #Scope = "link";
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
      protocol ospf wgserva {
          # import none;
          # export none;
          area 0 {
            interface "wgserva" {
            hello 10;
            retransmit 5;
            cost 10;
            transmit delay 1;
            dead count 4;
            wait 40;
            type broadcast;
            priority 1;
            authentication none;
            neighbors {
              2a0e:8f02:f017:2::1312;
            };
            };
          };
      }
    '';
  };
}
