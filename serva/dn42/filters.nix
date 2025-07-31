{
  lib,
  ...
}:
{
  services.bird = {
    config = lib.mkOrder 4 ''
      function is_valid_network4() {
        return net ~ [
          172.20.0.0/14{21,29}, # dn42
          172.20.0.0/24{28,32}, # dn42 Anycast
          172.21.0.0/24{28,32}, # dn42 Anycast
          172.22.0.0/24{28,32}, # dn42 Anycast
          172.23.0.0/24{28,32}, # dn42 Anycast
          172.31.0.0/16+,       # ChaosVPN
          10.100.0.0/14+,       # ChaosVPN
          10.127.0.0/16+,       # neonetwork
          10.0.0.0/8{15,24}     # Freifunk.net
        ];
      }

      function is_valid_network6() {
        return net ~ [
          fd00::/8+ 
        ];
      }

      function reject_invalid_net4() 
      {
        if net = !is_valid_network4() then {
          print "[dn42v4] Not importing ", net, " because it is not a valid IPv4 network", bgp_path;
          reject;
        }
      }

      function reject_invalid_net6() 
      {
        if net = !is_valid_network6() then {
          print "[dn42v4] Not importing ", net, " because it is not a valid IPv4 network", bgp_path;
          reject;
        }
      }

      function reject_ownnetset4() 
      {
        if net ~ OWNNETSET then {
          print "[dn42v4] Not importing ", net, " because it is selfnet ", bgp_path;
          reject;
        }
      }

      function reject_ownnetset6()
      {
        if net ~ OWNNETSETv6 then {
          print "[dn42v6] Not importing ", net, " because it is selfnet ", bgp_path;
          reject;
        }
      }

      function reject_roa_invalid() 
      {
        if roa_check(dn42_roa, net, bgp_path.last) != ROA_VALID then {
          print "[dn42v4] Not importing ", net, " because the ROA check failed for ASN ", bgp_path.last, " Full ASN path: ", bgp_path;
          reject;
        }
      }
    '';
  };
}
