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

      roa4 table dn42_roa;
      roa6 table dn42_roa_v6;

      protocol static {
          roa4 { table dn42_roa; };
          include "/etc/bird/roa_dn42.conf";
      };

      protocol static {
          roa6 { table dn42_roa_v6; };
          include "/etc/bird/roa_dn42_v6.conf";
      };

      log syslog all;

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
    '';

  };
}
