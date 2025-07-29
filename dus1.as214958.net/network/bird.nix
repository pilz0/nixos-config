{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./bgp-filters.nix
    ./bgp-peerings.nix
    ./rpki.nix
    ./bird_templates.nix
    #   ./routinator.nix # disabled due to resource usage
    #   ./bgp_to_serva.nix # disabled due to issues with the IPv6 connectivity from server
  ];

  networking.firewall.interfaces = {
    "ens18".allowedTCPPorts = [ 179 ];
    "ens19".allowedTCPPorts = [ 179 ];
  };

  systemd = {
    network = {
      config = {
        networkConfig = {
          # https://github.com/systemd/systemd/issues/36347
          ManageForeignRoutes = false;
          ManageForeignRoutingPolicyRules = false;
          IPv4Forwarding = true;
          IPv6Forwarding = true;

        };
      };
      wait-online = {
        enable = false;
        anyInterface = false;
      };
      enable = true;
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
          "2a0e:8f02:f017::1337/64"
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
    config = lib.mkOrder 3 ''
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
    '';
  };
}
