{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./peerings.nix
    ./bird-lg.nix
    ./rpki-dn42.nix
    ../bgp-filters
    ../bird-templates
    ../bird-default
    ../rpki
  ];
  age.secrets.wg = {
    file = ../../../secrets/wg.age;
    owner = "systemd-network";
    group = "systemd-network";
  };

  networking.nameservers = [
    "fd42:4242:2601:ac53::1"
    "172.20.129.1"
    "fd00:913e:130::400"
    "172.20.132.105"
  ];

  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];

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
          "fd49:d69f:6::1337/48"
          "172.22.179.129/27"
        ];
        networkConfig = {
          IPv4Forwarding = true;
          IPv6Forwarding = true;
        };
      };
    };
  };

  services.bird = {
    enable = true;
    package = pkgs.bird2;
    autoReload = true;
    config = lib.mkOrder 3 ''
      router id OWNIP_DN42;

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

      # Inject received BGP routes into the Linux kernel
      protocol kernel krnv4 {
      scan time 20;
      ipv4 {
        import none;
        export filter {
          if source = RTS_STATIC then reject;
          krt_prefsrc = OWNIP_DN42;
          accept;
        };
      };
      }

      protocol kernel krnv6 {
      scan time 20;
      ipv6 {
        import none;
        export filter {
          if source = RTS_STATIC then reject;
          krt_prefsrc = OWNIPv6_DN42;
          accept;
        };
      };
      }
    '';
  };
}
