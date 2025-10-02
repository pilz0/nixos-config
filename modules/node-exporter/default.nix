{
  config,
  ...
}:
{
  services.prometheus = {
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9100;
      };
    };
  };
  networking.firewall = {
    allowedTCPPorts = [
      config.services.prometheus.exporters.node.port
    ];
  };
}
