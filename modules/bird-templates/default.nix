{
  lib,
  ...
}:
{
  services.bird = {
    config = lib.mkOrder 4 ''
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

      # DN42 templates
      template bgp dnpeers {
        local as OWNAS_DN42;
        path metric 1; 
        enable extended messages on;
        graceful restart on;
        long lived graceful restart on;
        ipv4 {
          import table;
          extended next hop on;
          import limit 9000 action block;
          import filter {
            reject_invalid_net4_dn42();
            reject_ownnetset4_dn42();
            reject_roa_invalid4_dn42();
            accept;
          };
          export filter {
            accept;
          };
       };
      ipv6 {
          extended next hop on;
          import limit 9000 action block;
          import table; 
          import filter {
            reject_invalid_net6_dn42();
            reject_ownnetset6_dn42();
            reject_roa_invalid6_dn42();
            accept;
          };
          export filter {
            accept;
          };
        };
      }
    '';
  };
}
