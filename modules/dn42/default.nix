{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./peerings.nix
    ./peering_templates.nix
    ./filters.nix
    ./rpki.nix
    ./bird-lg.nix
  ];
  age.secrets.wg = {
    file = ../../secrets/wg.age;
    owner = "systemd-network";
    group = "systemd-network";
  };

  systemd = {
    network = {
      wait-online.enable = false;
      wait-online.anyInterface = false;
      enable = true;
      config.networkConfig = {
        IPv4Forwarding = true;
        IPv6Forwarding = true;
      };
      netdevs = {
        "50-cybertrash" = {
          enable = true;
          netdevConfig = {
            Kind = "dummy";
            Name = "cybertrash";
          };
        };
      };
      networks.cybertrash = {
        matchConfig.Name = "cybertrash";
        address = [
          "fd49:d69f:6::1337/112"
          "172.22.179.129/32"
        ];
      };
    };
  };

  services.bird = {
    enable = true;
    package = pkgs.bird2;
    autoReload = true;
    config = lib.mkOrder 1 ''
      define OWNAS = 4242420663;
      define OWNNET = 172.22.179.128/27;
      define OWNNETv6 = fd49:d69f:6::/48;
      define OWNNETSET = [ 172.22.179.128/27 ];
      define OWNNETSETv6 = [ fd49:d69f:6::/48 ];
      define OWNIP = 172.22.179.129;
      define OWNIPv6 = fd49:d69f:6::1337;

      ################################################
      #                 Header end                   #
      ################################################

      router id OWNIP;

      protocol device {
          scan time 10;
      }

      protocol kernel {
          scan time 20;

          ipv6 {
              import none;
              export filter {
                  if source = RTS_STATIC then reject;
                  krt_prefsrc = OWNIPv6;
                  accept;
              };
          };
      };

      protocol kernel {
          scan time 20;

          ipv4 {
              import none;
              export filter {
                  if source = RTS_STATIC then reject;
                  krt_prefsrc = OWNIP;
                  accept;
              };
          };
      }

      protocol static {
          route OWNNET reject;

          ipv4 {
              import all;
              export none;
          };
      }

      protocol static {
          route OWNNETv6 reject;

          ipv6 {
              import all;
              export none;
          };
      }
    '';
  };
}
