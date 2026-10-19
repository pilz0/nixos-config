{
  config,
  lib,
  ...
}:
let
  cfg = config.pilz.monitoring.systemd-exporter;
in
{
  options.pilz.monitoring.systemd-exporter = {
    enable = lib.mkEnableOption "";
    monitoring-servers-v6 = lib.mkOption {
      type = lib.types.str;
      default = "2a0e:8f02:f017::3,2a0f:be01:0:100::a3";
    };
    monitoring-servers-v4 = lib.mkOption {
      type = lib.types.str;
      default = "94.142.240.36,45.150.123.15";
    };
  };
  config = lib.mkIf cfg.enable {
    services.prometheus = {
      exporters = {
        systemd = {
          enable = true;
        };
      };
    };
    networking.firewall.extraCommands = ''
      ip6tables -I nixos-fw -p tcp -s ${cfg.monitoring-servers-v6} -m tcp --dport 9558 -j nixos-fw-accept
      iptables -I nixos-fw -p tcp -s ${cfg.monitoring-servers-v4} -m tcp --dport 9558 -j nixos-fw-accept
    '';
  };
}
