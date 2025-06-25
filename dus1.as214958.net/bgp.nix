{
  pkgs,
  ...
}:
{
  imports = [
    # ./servperso.nix
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
        "50-Dummyinter" = {
          enable = true;
          netdevConfig = {
            Kind = "dummy";
            Name = "Dummyinter";
          };
        };
      };

      networks.cybertrash = {
        matchConfig.Name = "dummyinter";
        address = [
          "2a0e:8f02:f017::1337/48"
        ];
      };
    };
  };

  services.bird-lg = {
    proxy = {
      enable = true;
      listenAddress = "2a0e:8f02:f017::1337";
      allowedIPs = [ "::0/0" ];
    };
    frontend = {
      domain = "lg.as214958.net";
      enable = true;
      servers = [ "serva" ];
      protocolFilter = [
        "bgp"
        "static"
      ];
      listenAddress = "[::1]:15000";
      proxyPort = 18000;
      navbar = {
        brand = "as214958.net";
      };
    };
  };

  services.bird = {
    enable = true;
    package = pkgs.bird2;
    autoReload = true;
    config = ''
      # Define your router ID, usually your VPS IP
      router id 225.3.77.150;

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

      # Filter to only announce your assigned prefixes
      filter filter_to_upstream {
              if (net.type = NET_IP6 && net ~ [ 2a0e:8f02:f017::/48 ]) then accept;
              reject;
      };

      # IPv6 BGP session with Servperso
      protocol bgp BGP_Servperso_V6 {
              local as 214958;
              neighbor 2a0c:b640:10::3:ffff as 34872;
              ipv6 {
                      import all;
                      export filter filter_to_upstream;
              };
      }    
    '';
  };
}
