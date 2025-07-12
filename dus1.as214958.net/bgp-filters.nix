{
  lib,
  ...
}:
{
  services.bird = {
    config = lib.mkBefore ''
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
      function reject_default_route4()
      {
        if net = 0.0.0.0/0 then {
          # optional logging:
          # print "Reject: Defaultroute: ", net, " ", bgp_path;
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
      define BOGON_PREFIXES4 = [  0.0.0.0/8+,         # RFC 1122 'this' Network
                                  10.0.0.0/8+,        # RFC 1918 Private
                                  100.64.0.0/10+,     # RFC 6598 Carrier grade nat space
                                  127.0.0.0/8+,       # RFC 1122 Loopback
                                  169.254.0.0/16+,    # RFC 3927 Link Local
                                  172.16.0.0/12+,     # RFC 1918 Private
                                  192.0.2.0/24+,      # RFC 5737 Documentation TEST-NET-1
                                  192.168.0.0/16+,    # RFC 1918 Private
                                  198.18.0.0/15+,     # RFC 2544 Benchmarking
                                  198.51.100.0/24+,   # RFC 5737 Documentation TEST-NET-2
                                  203.0.113.0/24+,    # RFC 5737 Documentation TEST-NET-3
                                  224.0.0.0/4+,       # RFC 5771 Multicast
                                  240.0.0.0/4+        # RFC 1112 Reserved
      ];

      function reject_bogon_prefixes4()
      prefix set bogon_prefixes4;
      {
          bogon_prefixes4 = BOGON_PREFIXES4;
          if (net ~ bogon_prefixes4) then {
              print "Reject: Bogon prefix: ", net, " ", bgp_path;
              reject;
          }
      }
      define BOGON_PREFIXES6 = [ ::/8+,                        # RFC 4291 IPv4-compatible, loopback, et al
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

      function reject_bogon_prefixes6()
      prefix set bogon_prefixes6;
      {
          bogon_prefixes6 = BOGON_PREFIXES6;
          if (net ~ bogon_prefixes6) then {
              print "Reject: Bogon prefix: ", net, " ", bgp_path;
              reject;
          }
      }
      function reject_small_prefixes4()
      {
        # do not accept too short prefixes
        if (net.len > 24) then {
          print "Reject: Too small prefix: ", net, " ", bgp_path;
          reject;
        }
      }

      function reject_small_prefixes6()
      {
        # do not accept too short prefixes
        if (net.len > 48) then {
          print "Reject: Too small prefix: ", net, " ", bgp_path;
          reject;
        }
      }
      define IXP_PREFIXES4 = [
        185.1.155.0/24 # LocIX DUS
      ];
      define IXP_PREFIXES6 = [
        2a0c:b641:701::/64 # LocIX DUS
      ];
      function reject_ixp_prefixes4()
      prefix set ixp_prefixes4;
      {
        ixp_prefixes4 = IXP_PREFIXES4;
        if (net ~ ixp_prefixes4) then {
          reject;
        }
      }
      function reject_ixp_prefixes6()
      prefix set ixp_prefixes6;
      {
        ixp_prefixes6 = IXP_PREFIXES6;
        if (net ~ ixp_prefixes6) then {
          reject;
        }
      }

    '';
  };
}
