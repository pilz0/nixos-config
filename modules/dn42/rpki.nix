{
  lib,
  ...
}:
{
  services.bird = {
    config = lib.mkOrder 3 ''
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
    '';
  };
}
