{
  config,
  lib,
  ...
}:
let
  cfg = config.pilz.monitoring.node-exporter;
in
{
  options.pilz.monitoring.node-exporter = {
    enable = lib.mkEnableOption "";
    monitoring-servers-v4 = lib.mkOption {
      type = lib.types.str;
      default = "94.142.240.36";
    };
    monitoring-servers-v6 = lib.mkOption {
      type = lib.types.str;
      default = "2a0e:8f02:f017::3";
    };
  };
  config = lib.mkIf cfg.enable {
    services.prometheus = {
      exporters = {
        node = {
          enable = true;
        };
      };
    };
    networking.firewall.extraCommands = ''
      iptables -I nixos-fw -p tcp -s ${cfg.monitoring-servers-v4} -m tcp --dport 9100 -j nixos-fw-accept
      ip6tables -I nixos-fw -p tcp -s ${cfg.monitoring-servers-v6} -m tcp --dport 9100 -j nixos-fw-accept
    '';
  };
}
