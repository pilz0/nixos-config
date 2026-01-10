{
  lib,
  ...
}:
{
  services.prometheus = {
    exporters = {
      bird = {
        enable = true;
      };
    };
  };
  services.bird = {
    preCheckConfig = lib.mkOrder 2 ''
      # Remove roa files for checking, because they are only available at runtime
      sed -i 's|include "/etc/bird/roa_dn42.conf";||' bird.conf
      sed -i 's|include "/etc/bird/roa_dn42_v6.conf";||' bird.conf

      cat -n bird.conf
    '';
    config = lib.mkOrder 1 ''
      # DN42 stuff, should be moved somewhere else
      define OWNAS_DN42 = 4242420663;
      define OWNNET_DN42 = 172.22.179.128/27;
      define OWNNETv6_DN42 = fd49:d69f:6::/48;
      define OWNNETSET_DN42 = [ 172.22.179.128/27 ];
      define OWNNETSETv6_DN42 = [ fd49:d69f:6::/48 ];
      define OWNIP_DN42 = 172.22.179.129;
      define OWNIPv6_DN42 = fd49:d69f:6::1337;

      log syslog all;

      define PREFIXES_ANNOUNCED_V4 = [
        94.142.241.152/31
      ];
      define PREFIXES_ANNOUNCED_V6 = [
        2a0e:8f02:f017::/48,
        2a02:898:427::/48
      ];
      define PREFIXES_ANNOUNCED_V4_DN42 = [
        172.22.179.128/27
      ];
      define PREFIXES_ANNOUNCED_V6_DN42 = [
        fd49:d69f:6::/48
      ];

      roa4 table dn42_roa;
      roa6 table dn42_roa_v6;

      protocol device {
        scan time 10;
      }

      protocol static {
        roa4 { table dn42_roa; };
        include "/etc/bird/roa_dn42.conf";
      };

      protocol static {
        roa6 { table dn42_roa_v6; };
        include "/etc/bird/roa_dn42_v6.conf";
      };

    '';

  };
}
