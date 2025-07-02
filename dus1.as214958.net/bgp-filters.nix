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
    '';
  };
}
