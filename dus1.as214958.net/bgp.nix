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
        "50-dummyinter" = {
          enable = true;
          netdevConfig = {
            Kind = "dummy";
            Name = "dummyinter";
          };
        };
      };

      networks.cybertrash = {
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

  services.bird-lg = {
    proxy = {
      enable = true;
      listenAddress = "[2a0c:b640:10::2:44]:18000";
      allowedIPs = [ "::0/0" ];
    };
    frontend = {
      domain = "lg.as214958.net";
      enable = true;
      servers = [ "dus1" ];
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

      function reject_long_aspaths()
      {
        if ( bgp_path.len > 50 ) then {
          # optional logging:
          # print "Reject: Too long AS path: ", net, " ", bgp_path;
          reject;
        }
      }

      define BOGON_ASNS = [
        0,                      # RFC 7607
        23456,                  # RFC 4893 AS_TRANS
        64496..64511,           # RFC 5398 and documentation/example ASNs
        64512..65534,           # RFC 6996 Private ASNs
        65535,                  # RFC 7300 Last 16 bit ASN
        65536..65551,           # RFC 5398 and documentation/example ASNs
        65552..131071,          # RFC IANA reserved ASNs
        4200000000..4294967294, # RFC 6996 Private ASNs
        4294967295              # RFC 7300 Last 32 bit ASN
      ];
      function reject_bogon_asns()
      int set bogon_asns;
      {
        bogon_asns = BOGON_ASNS;
        if ( bgp_path ~ bogon_asns ) then {
          # optional logging:
          # print "Reject: bogon AS_PATH: ", net, " ", bgp_path;
          reject;
        }
      }

      function reject_default_route6()
      {
        if net = ::/0 then {
          # optional logging:
          # print "Reject: Defaultroute: ", net, " ", bgp_path;
          reject;
        }
      }
      define BOGON_PREFIXES = [ ::/8+,                         # RFC 4291 IPv4-compatible, loopback, et al
                                0100::/64+,                    # RFC 6666 Discard-Only
                                2001:2::/48+,                  # RFC 5180 BMWG
                                2001:10::/28+,                 # RFC 4843 ORCHID
                                2001:db8::/32+,                # RFC 3849 documentation
                                3fff::/20+,                    # RFC 9637 documentation
                                2002::/16+,                    # RFC 7526 6to4 anycast relay
                                3ffe::/16+,                    # RFC 3701 old 6bone
                                5f00::/16+,                    # RFC 9602 SRv6
                                fc00::/7+,                     # RFC 4193 unique local unicast
                                fe80::/10+,                    # RFC 4291 link local unicast
                                fec0::/10+,                    # RFC 3879 old site local unicast
                                ff00::/8+                      # RFC 4291 multicast
      ];

      function reject_bogon_prefixes()
      prefix set bogon_prefixes;
      {
          bogon_prefixes = BOGON_PREFIXES;
          if (net ~ bogon_prefixes) then {
              print "Reject: Bogon prefix: ", net, " ", bgp_path;
              reject;
          }
      }
      function filter_import_v6()
      {
        # do not accept too short prefixes
        if (net.len > 48) then {
          print "Reject: Too small prefix: ", net, " ", bgp_path;
          reject;
        }
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

      protocol bgp Servperso_V6 from peers {
              neighbor 2a0c:b640:10::2:ffff as 34872;
      }

      protocol bgp RS1_LOCIX_DUS from peers {
              neighbor 2a0c:b641:701::a5:20:2409:1 as 202409;
      }

      protocol bgp RS2_LOCIX_DUS from peers {
              neighbor 2a0c:b641:701::a5:20:2409:2 as 202409;
      }
      protocol bgp AS112_LOCIX_DUS from peers {
              neighbor 2a0c:b641:701:0:a5:0:112:1 as 112;
      }     
    '';
  };
}
