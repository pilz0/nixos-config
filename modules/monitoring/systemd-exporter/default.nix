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
    monitoring-servers = lib.mkOption {
      type = lib.types.str;
      default = "2a0e:8f02:f017::3";
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
      ip6tables -I nixos-fw -p tcp -s ${cfg.monitoring-servers} -m tcp --dport 9558 -j nixos-fw-accept
    '';
  };
}
