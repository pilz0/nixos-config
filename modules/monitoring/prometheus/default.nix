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
              targets = with config.services.prometheus.exporters; [
                "[2a0e:8f02:f017::1]:${toString node.port}"
                "[2a0e:8f02:f017::1]:${toString bird.port}"
                "web1.ams1.as214958.net:${toString node.port}"
                "web1.ams1.as214958.net:${toString nginx.port}"
                "grafana.ams1.as214958.net:${toString node.port}"
                "jellyfin.ams1.as214958.net:${toString node.port}"
                "jellyfin.ams1.as214958.net:${toString wireguard.port}"
                "rpki.ams1.as214958.net:${toString node.port}"
                "dn42.ams1.as214958.net:${toString node.port}"
                "netbox.ams1.as214958.net:${toString node.port}"
                "build.ams1.as214958.net:${toString node.port}"
                "web1.ams1.as214958.net:${toString systemd.port}"
                "grafana.ams1.as214958.net:${toString systemd.port}"
                "jellyfin.ams1.as214958.net:${toString systemd.port}"
                "rpki.ams1.as214958.net:${toString systemd.port}"
                "dn42.ams1.as214958.net:${toString systemd.port}"
                "netbox.ams1.as214958.net:${toString systemd.port}"
                "build.ams1.as214958.net:${toString systemd.port}"
                "grafana.ams1.as214958.net:9590" # netflow exporter
                "anodyne.wiki:${toString node.port}"
                "build-aarch64.as214958.net:${toString node.port}"
                "build-aarch64.as214958.net:${toString systemd.port}"
                "build-aarch64-2.as214958.net:${toString node.port}"
                "build-aarch64-2.as214958.net:${toString systemd.port}"
                "anodyne-primary.ams1.as214958.net:${toString node.port}"
                "anodyne-secondary.dus1.as214958.net:${toString node.port}"
                "anodyne-primary.ams1.as214958.net:${toString systemd.port}"
                "anodyne-secondary.dus1.as214958.net:${toString systemd.port}"
              ];
            }
          ];
        }
        {
          job_name = "tor";
          scrape_interval = "30s";
          static_configs = [
            {
              targets = lib.concatMap (num:
                map (p:
                  "tor${toString num}.ams1.as214958.net:${toString p}"
                ) (with config.services.prometheus.exporters; [
                  node.port
                  systemd.port
                  9052
                ])
              ) (lib.range 1 8) ++ (with config.services.prometheus.exporters; [
                "tor1.catgirl.dog:${toString node.port}"
                "tor2.catgirl.dog:${toString node.port}"
              ]);
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
                "https://anodyne-nix.as214958.net"
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
