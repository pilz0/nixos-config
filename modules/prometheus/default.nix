{
  config,
  ...
}:
{
  age.secrets = {
    rclone = {
      file = ../../secrets/rclone.age;
      owner = "prometheus";
      group = "prometheus";
    };
    restic = {
      file = ../../secrets/restic.age;
      owner = "prometheus";
      group = "prometheus";
    };
    nextcloud-exporter = {
      file = ../../secrets/nextcloud-exporter.age;
      owner = "prometheus";
      group = "prometheus";
    };
  };

  services.prometheus = {
    enable = true;
    port = 1312;
    scrapeConfigs = [
      {
        job_name = "nodes";
        scrape_interval = "30s";
        static_configs = [
          {
            targets = [
              "shit.ketamin.trade:${toString config.services.prometheus.exporters.node.port}"
              "tor1.ketamin.trade:${toString config.services.prometheus.exporters.node.port}"
              "tor2.ketamin.trade:${toString config.services.prometheus.exporters.node.port}"
              "tor3.ketamin.trade:${toString config.services.prometheus.exporters.node.port}"
              "tor4.ketamin.trade:${toString config.services.prometheus.exporters.node.port}"
              "tor1.ams1.as214958.net:${toString config.services.prometheus.exporters.node.port}"
              "tor2.ams1.as214958.net:${toString config.services.prometheus.exporters.node.port}"
              "tor3.ams1.as214958.net:${toString config.services.prometheus.exporters.node.port}"
              "tor4.ams1.as214958.net:${toString config.services.prometheus.exporters.node.port}"
              "tor5.ams1.as214958.net:${toString config.services.prometheus.exporters.node.port}"
              "tor6.ams1.as214958.net:${toString config.services.prometheus.exporters.node.port}"
              "tor7.ams1.as214958.net:${toString config.services.prometheus.exporters.node.port}"
              "tor8.ams1.as214958.net:${toString config.services.prometheus.exporters.node.port}"
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
              "10.10.10.1:${toString config.services.prometheus.exporters.smartctl.port}"
              "10.10.10.1:${toString config.services.prometheus.exporters.node.port}"
              "10.10.10.1:${toString config.services.prometheus.exporters.bird.port}"
              "[2a0e:8f02:f017::1]:${toString config.services.prometheus.exporters.node.port}"
              "web1.web1.ams1.as214958.net:${toString config.services.prometheus.exporters.node.port}"
              "grafana.ams1.as214958.net:${toString config.services.prometheus.exporters.node.port}"
              "jellyfin.ams1.as214958.net:${toString config.services.prometheus.exporters.node.port}"
              "rpki.ams1.as214958.net:${toString config.services.prometheus.exporters.node.port}"
              "dn42.ams1.as214958.net:${toString config.services.prometheus.exporters.node.port}"
              "netbox.ams1.as214958.net:${toString config.services.prometheus.exporters.node.port}"
              "build.ams1.as214958.net:${toString config.services.prometheus.exporters.node.port}"
              "[2a0e:8f02:f017::1]:${toString config.services.prometheus.exporters.bird.port}"
              "grafana.ams1.as214958.net:9590" # netflow exporter
            ];
          }
        ];
      }
    ];
  };
}
