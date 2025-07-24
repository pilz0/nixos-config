{
  pkgs,
  ...
}:
{
  imports = [
    ./bgp-filters.nix
    ./bgp-peerings.nix
    ./looking-glass.nix
    #   ./rpki.nix # disabled due to resource usage
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
          ManageForeignRoutes = false;
          ManageForeignRoutingPolicyRules = false;
        };
      };
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
    config = ''
      log syslog all;

      router id 225.3.77.150;

      roa4 table rpki4;
      roa6 table rpki6;

      protocol rpki routinator1 {
        roa4 { table rpki4; };
        roa6 { table rpki6; };
        remote "rpki.level66.network" port 3323;
        retry keep 90;
        refresh keep 900;
        expire keep 172800;
      }
      protocol rpki routinator2 {
        roa4 { table rpki4; };
        roa6 { table rpki6; };
        remote "rpki.zotan.network" port 3323;
        retry keep 90;
        refresh keep 900;
        expire keep 172800;
      }
      function reject_rpki_invalid4() 
      {
        if roa_check(rpki4, net, bgp_path.last_nonaggregated) = ROA_INVALID then {
          print "Reject: RPKI invalid: ", net, " ", bgp_path;
          reject;
        }
      }

      function reject_rpki_invalid6() 
      {
        if roa_check(rpki6, net, bgp_path.last_nonaggregated) = ROA_INVALID then {
          print "Reject: RPKI invalid: ", net, " ", bgp_path;
          reject;
        }
      }
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

      template bgp ibgp {
        path metric 1;
        local as 214958;
        enable extended messages on;
        graceful restart on;
        long lived graceful restart on;
        ipv4 {
            import keep filtered;
            import filter {
              reject_long_aspaths();
              reject_bogon_asns();
              reject_default_route4();
              reject_bogon_prefixes4();
              reject_ixp_prefixes4();
              reject_rpki_invalid4();
              accept;
            };
            export filter {
              # if (net.type = NET_IP4 && net ~ [ ]) then accept;
              reject;
            };
        };
        ipv6 {
            import keep filtered;
            import filter {
              reject_long_aspaths();
              reject_bogon_asns();
              reject_default_route6();
              reject_bogon_prefixes6();
              reject_ixp_prefixes6();
              reject_rpki_invalid6();
              accept;
            };
            export filter {
              accept;
            };
        };
      }

      template bgp ebgp {
          path metric 1;
          local as 214958;
          enable extended messages on;
          graceful restart on;
          long lived graceful restart on;
          ipv4 {
              import keep filtered;
              import filter {
                reject_long_aspaths();
                reject_bogon_asns();
                reject_default_route4();
                reject_bogon_prefixes4();
                reject_ixp_prefixes4();
                reject_small_prefixes4();
                reject_rpki_invalid4();
                strip_too_many_communities();
                honor_graceful_shutdown();
                accept;
              };
              export filter {
                # if (net.type = NET_IP4 && net ~ [ ]) then accept;
                reject;
              };
          };
          ipv6 {
              import keep filtered;
              import filter {
                reject_long_aspaths();
                reject_bogon_asns();
                reject_default_route6();
                reject_bogon_prefixes6();
                reject_ixp_prefixes6();
                reject_small_prefixes6();
                reject_rpki_invalid6();
                strip_too_many_communities();
                honor_graceful_shutdown();
                accept;
              };
              export filter {
                if (net.type = NET_IP6 && net ~ [ 2a0e:8f02:f017::/48 ]) then accept;
                reject;
              };
          };
      }

      template bgp peers from ebgp {
        ipv4 {
          import filter {
            reject_long_aspaths();
            reject_bogon_asns();
            reject_default_route4();
            reject_bogon_prefixes4();
            reject_ixp_prefixes4();
            reject_small_prefixes4();
            reject_rpki_invalid4();
            strip_too_many_communities();
            honor_graceful_shutdown();
            reject_transit_paths();
            accept;
          };
          import limit 1000 action restart;
        };
        ipv6 {
          import filter {
            reject_long_aspaths();
            reject_bogon_asns();
            reject_default_route6();
            reject_bogon_prefixes6();
            reject_ixp_prefixes6();
            reject_small_prefixes6();
            reject_rpki_invalid6();
            strip_too_many_communities();
            honor_graceful_shutdown();
            reject_transit_paths();
            accept;
          };
          import limit 500 action restart;
        };
      }
      template bgp rs_peer from ebgp {
        ipv4 {
          import filter {
            reject_long_aspaths();
            reject_bogon_asns();
            reject_default_route4();
            reject_bogon_prefixes4();
            reject_ixp_prefixes4();
            reject_small_prefixes4();
            reject_rpki_invalid4();
            strip_too_many_communities();
            honor_graceful_shutdown();
            reject_transit_paths();
            accept;
          };
          import limit 450000 action restart;
        };
        ipv6 {
          import filter {
            reject_long_aspaths();
            reject_bogon_asns();
            reject_default_route6();
            reject_bogon_prefixes6();
            reject_ixp_prefixes6();
            reject_small_prefixes6();
            reject_rpki_invalid6();
            strip_too_many_communities();
            honor_graceful_shutdown();
            reject_transit_paths();
            accept;
          };
          import limit 150000 action restart;
        };
      }
      template bgp client from ebgp {
        ipv4 {
          import limit 3000000 action restart;
        };
        ipv6 {
          import limit 400000 action restart;
        };
      }
    '';
  };
}
