{
  pkgs,
  ...
}:
{
  imports = [
    ./bgp-filters.nix
    ./bgp-peerings.nix
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
        "50-dummyinter" = {
          enable = true;
          netdevConfig = {
            Kind = "dummy";
            Name = "dummyinter";
          };
        };
      };

      networks.dummyinter = {
        matchConfig.Name = "dummyinter";
        address = [
          "2a0e:8f02:f017::/48"
        ];
        networkConfig = {
          ConfigureWithoutCarrier = true;
        };
      };
    };
  };

  services.bird = {
    enable = true;
    package = pkgs.bird2;
    autoReload = true;
    config = ''
      log syslog all;

      router id 225.3.77.150;

      protocol device {
      scan time 60;
      }

      # Inject received BGP routes into the Linux kernel
      protocol kernel krnv4 {
              scan time 60;
              ipv4 {
                      import none;
                      export all;
              };
      }

      protocol kernel krnv6 {
              scan time 60;
              ipv6 {
                      import none;
                      export all;
              };
      }

      protocol static announce_ipv6 {
              ipv6;
              route 2a0e:8f02:f017::/48 unreachable;
      }

      template bgp peers {
          path metric 1;
          local as 214958;
          enable extended messages on;
          graceful restart on;
          long lived graceful restart on;
          ipv6 {
              import keep filtered;
              import filter {
                reject_long_aspaths();
                reject_bogon_asns();
                reject_default_route6();
                reject_bogon_prefixes();
                filter_import_v6();
                accept;
              };
              export filter {
                if (net.type = NET_IP6 && net ~ [ 2a0e:8f02:f017::/48 ]) then accept;
                reject;
              };
          };
      }
    '';
  };
}
