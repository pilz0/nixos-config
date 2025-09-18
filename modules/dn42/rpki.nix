{
  lib,
  pkgs,
  ...
}:
let
  script = pkgs.writeShellScriptBin "update-roa" ''
    mkdir -p /etc/bird/
    ${pkgs.curl}/bin/curl -sfSLR {-o,-z}/etc/bird/roa_dn42_v6.conf https://dn42.burble.com/roa/dn42_roa_bird2_6.conf
    ${pkgs.curl}/bin/curl -sfSLR {-o,-z}/etc/bird/roa_dn42.conf https://dn42.burble.com/roa/dn42_roa_bird2_4.conf
    ${pkgs.bird2}/bin/birdc c 
    ${pkgs.bird2}/bin/birdc reload in all
  '';
in
{
  systemd = {
    services = {
      dn42-roa = {
        after = [ "network.target" ];
        description = "DN42 ROA Updated";
        unitConfig = {
          Type = "one-shot";
        };
        serviceConfig = {
          ExecStart = "${script}/bin/update-roa";
        };
      };
    };
    timers.dn42-roa = {
      description = "Trigger a ROA table update";

      timerConfig = {
        OnBootSec = "5m";
        OnUnitInactiveSec = "1h";
        Unit = "dn42-roa.service";
      };

      wantedBy = [ "timers.target" ];
      before = [ "bird.service" ];
    };
  };

  services.bird = {
    preCheckConfig = lib.mkOrder 2 ''
      # Remove roa files for checking, because they are only available at runtime
      sed -i 's|include "/etc/bird/roa_dn42.conf";||' bird.conf
      sed -i 's|include "/etc/bird/roa_dn42_v6.conf";||' bird.conf

      cat -n bird.conf
    '';
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
