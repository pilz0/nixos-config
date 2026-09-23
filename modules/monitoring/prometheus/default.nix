{
  config,
  lib,
  ...
}:
{
  options.pilz.monitoring.prometheus = {
    enable = lib.mkEnableOption "";
    port = lib.mkOption {
      type = lib.types.int;
      default = 1312;
    };
  };

  config = lib.mkIf config.pilz.monitoring.prometheus.enable {
    services.prometheus = {
      enable = true;
      port = config.pilz.monitoring.prometheus.port;
      retentionTime = "7d";
      scrapeConfigs = [
        {
          job_name = "nodes";
          scrape_interval = "30s";
          static_configs = [
            {
              targets = [
                "[2a0e:8f02:f017::1]:${toString config.services.prometheus.exporters.node.port}"
                "[2a0e:8f02:f017::1]:${toString config.services.prometheus.exporters.bird.port}"
                "web1.ams1.as214958.net:${toString config.services.prometheus.exporters.node.port}"
                "web1.ams1.as214958.net:${toString config.services.prometheus.exporters.nginx.port}"
                "grafana.ams1.as214958.net:${toString config.services.prometheus.exporters.node.port}"
                "jellyfin.ams1.as214958.net:${toString config.services.prometheus.exporters.node.port}"
                "rpki.ams1.as214958.net:${toString config.services.prometheus.exporters.node.port}"
                "dn42.ams1.as214958.net:${toString config.services.prometheus.exporters.node.port}"
                "netbox.ams1.as214958.net:${toString config.services.prometheus.exporters.node.port}"
                "build.ams1.as214958.net:${toString config.services.prometheus.exporters.node.port}"
                "web1.ams1.as214958.net:${toString config.services.prometheus.exporters.systemd.port}"
                "grafana.ams1.as214958.net:${toString config.services.prometheus.exporters.systemd.port}"
                "jellyfin.ams1.as214958.net:${toString config.services.prometheus.exporters.systemd.port}"
                "rpki.ams1.as214958.net:${toString config.services.prometheus.exporters.systemd.port}"
                "dn42.ams1.as214958.net:${toString config.services.prometheus.exporters.systemd.port}"
                "netbox.ams1.as214958.net:${toString config.services.prometheus.exporters.systemd.port}"
                "build.ams1.as214958.net:${toString config.services.prometheus.exporters.systemd.port}"
                "grafana.ams1.as214958.net:9590" # netflow exporter
                "anodyne.wiki:${toString config.services.prometheus.exporters.node.port}"
                "build-aarch64.as214958.net:${toString config.services.prometheus.exporters.node.port}"
                "build-aarch64.as214958.net:${toString config.services.prometheus.exporters.systemd.port}"
              ];
            }
          ];
        }
        {
          job_name = "tor";
          scrape_interval = "30s";
          static_configs = [
            {
              targets = [
                "tor1.ams1.as214958.net:${toString config.services.prometheus.exporters.node.port}"
                "tor2.ams1.as214958.net:${toString config.services.prometheus.exporters.node.port}"
                "tor3.ams1.as214958.net:${toString config.services.prometheus.exporters.node.port}"
                "tor4.ams1.as214958.net:${toString config.services.prometheus.exporters.node.port}"
                "tor5.ams1.as214958.net:${toString config.services.prometheus.exporters.node.port}"
                "tor6.ams1.as214958.net:${toString config.services.prometheus.exporters.node.port}"
                "tor7.ams1.as214958.net:${toString config.services.prometheus.exporters.node.port}"
                "tor8.ams1.as214958.net:${toString config.services.prometheus.exporters.node.port}"
                "tor1.ams1.as214958.net:${toString config.services.prometheus.exporters.systemd.port}"
                "tor2.ams1.as214958.net:${toString config.services.prometheus.exporters.systemd.port}"
                "tor3.ams1.as214958.net:${toString config.services.prometheus.exporters.systemd.port}"
                "tor4.ams1.as214958.net:${toString config.services.prometheus.exporters.systemd.port}"
                "tor5.ams1.as214958.net:${toString config.services.prometheus.exporters.systemd.port}"
                "tor6.ams1.as214958.net:${toString config.services.prometheus.exporters.systemd.port}"
                "tor7.ams1.as214958.net:${toString config.services.prometheus.exporters.systemd.port}"
                "tor8.ams1.as214958.net:${toString config.services.prometheus.exporters.systemd.port}"
                "tor1.ams1.as214958.net:9052" # tor
                "tor2.ams1.as214958.net:9052" # tor
                "tor3.ams1.as214958.net:9052" # tor
                "tor4.ams1.as214958.net:9052" # tor
                "tor5.ams1.as214958.net:9052" # tor
                "tor6.ams1.as214958.net:9052" # tor
                "tor7.ams1.as214958.net:9052" # tor
                "tor8.ams1.as214958.net:9052" # tor
                "tor1.catgirl.dog:${toString config.services.prometheus.exporters.node.port}"
                "tor2.catgirl.dog:${toString config.services.prometheus.exporters.node.port}"
              ];
            }
          ];
        }
        {
          job_name = "blackbox";
          metrics_path = "/probe";
          params.module = [ "http-2xx" ];
          static_configs = [
            {
              targets = [
                "https://anodyne.wiki"
                "https://watch.kyouma.net"
                "https://jellyfin.pilz.foo"
                "https://cocaine.trade"
                "https://flohannes.de"
                "https://florp.social"
              ];
            }
          ];
          relabel_configs = [
            {
              source_labels = [ "__address__" ];
              target_label = "__param_target";
            }
            {
              source_labels = [ "__param_target" ];
              target_label = "instance";
            }
            {
              target_label = "__address__";
              replacement = "localhost:9115";
            }
          ];
        }
        {
          job_name = "ping-probe";
          metrics_path = "/probe";
          params.module = [ "icmp" ];
          static_configs = [
            {
              targets = [
                "tomate.kyouma.net"
              ];
            }
          ];
          relabel_configs = [
            {
              source_labels = [ "__address__" ];
              target_label = "__param_target";
            }
            {
              source_labels = [ "__param_target" ];
              target_label = "instance";
            }
            {
              target_label = "__address__";
              replacement = "localhost:9115";
            }
          ];
        }
      ];
    };
  };
}
