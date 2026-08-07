{
  lib,
  ...
}:
{
  services.bird = {
    config = lib.mkOrder 2 ''
      # https://routing.denog.de/guides/route_filtering/inbound/rpki/
      roa4 table rpki4;
      roa6 table rpki6;
      aspa table aspatable;

      protocol rpki rpki_as214958_net {
        roa4 { table rpki4; };
        roa6 { table rpki6; };
        aspa { table aspatable; };
        remote "rpki.ams1.as214958.net" port 3323;
        retry keep 90;
        refresh keep 900;
        expire keep 172800;
      }

      protocol rpki rpki_cloudflare {
        roa4 { table rpki4; };
        roa6 { table rpki6; };
        remote "rtr.rpki.cloudflare.com" port 8282;
        retry keep 90;
        refresh keep 900;
        expire keep 172800;
      }

      function reject_aspa_invalid()
      {
        if aspa_check(aspatable, bgp_path, false) = ASPA_INVALID then {
            print "Reject: ASPA invalid: ", " ", bgp_path;
            reject;
        }
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
    '';
  };

}
