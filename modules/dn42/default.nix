{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./peerings.nix
    ./bird-lg.nix
    ../../modules/bgp-filters
    ../../modules/bird-templates
    ../../modules/bird-default
    ../../modules/rpki
    ../../modules/rpki-dn42
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
    config = lib.mkOrder 3 ''
      router id 172.22.179.129;

      protocol static {
          route OWNNET_DN42 reject;

          ipv4 {
              import all;
              export none;
          };
      }

      protocol static {
          route OWNNETv6_DN42 reject;

          ipv6 {
              import all;
              export none;
          };
      }
    '';
  };
}
