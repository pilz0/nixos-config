{
  config,
  lib,
  ...
}:
{
  options.pilz.monitoring.node-exporter = {
    enable = lib.mkEnableOption "";
  };
  config = lib.mkIf config.pilz.monitoring.node-exporter.enable {
    services.prometheus = {
      exporters = {
        node = {
          enable = true;
          enabledCollectors = [ "systemd" ];
        };
      };
    };
  };
}
