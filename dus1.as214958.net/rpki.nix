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
    '';
  };

}
