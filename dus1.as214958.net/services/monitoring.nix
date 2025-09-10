{
  config,
  ...
}:
{
  imports = [
    ./netflow-exporter.nix
  ];
  services.prometheus = {
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9100;
      };
      wireguard = {
        enable = true;
        withRemoteIp = true;
      };
      smokeping = {
        enable = true;
        hosts = [
          "google.com"
          "ip6.clerie.de"
        ];
      };
    };
  };
  networking.firewall = {
    allowedTCPPorts = [
      config.services.prometheus.exporters.wireguard.port
      config.services.prometheus.exporters.smokeping.port
      config.services.prometheus.exporters.node.port
    ];
  };
}
