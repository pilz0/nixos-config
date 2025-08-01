{
  lib,
  ...
}:
{
  services.bird = {
    config = lib.mkOrder 5 ''
      template bgp dnpeers {
        local as OWNAS;
        path metric 1;
        
        enable extended messages on;
        graceful restart on;
        long lived graceful restart on;

        ipv4 {
            extended next hop on;
            import filter {
              reject_invalid_net4();
              reject_ownnetset4();
              reject_roa_invalid4();
              print "[dn42v4] Importing ", net, " AS PATH: ", bgp_path;
              accept;
            };
            export filter {
              accept;
            };
            import limit 9000 action block;
        import table;
        };

        ipv6 {
            extended next hop on;
            import filter {
              reject_invalid_net6();
              reject_ownnetset6();
              reject_roa_invalid6();
              print "[dn42] Importing ", net, " AS PATH: ", bgp_path;
              accept;
            };
            export filter {
              accept;
            };
            import limit 9000 action block;
        import table; 
        };
      }
    '';
  };
}
