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
  };
  config = lib.mkIf cfg.enable {
    services.prometheus = {
      exporters = {
        node.enable = true;
        systemd.enable = true;
      };
    };
    networking.firewall.extraCommands = ''
      ip6tables -I nixos-fw -p tcp -s ${config.monitoring.servers.v6} -m tcp --dport 9558 -j nixos-fw-accept
      iptables -I nixos-fw -p tcp -s ${config.monitoring.servers.v4} -m tcp --dport 9558 -j nixos-fw-accept
      iptables -I nixos-fw -p tcp -s ${config.monitoring.servers.v4}-m tcp --dport 9100 -j nixos-fw-accept
      ip6tables -I nixos-fw -p tcp -s ${config.monitoring.servers.v6} -m tcp --dport 9100 -j nixos-fw-accept
    '';
  };
}
