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
              "tor1.ketamin.trade:9191" # Fail2ban Exporer
              "tor2.ketamin.trade:${toString config.services.prometheus.exporters.node.port}"
              "tor2.ketamin.trade:9191" # Fail2ban Exporer
              "tor3.ketamin.trade:${toString config.services.prometheus.exporters.node.port}"
              "tor3.ketamin.trade:9191" # Fail2ban Exporer
              "tor4.ketamin.trade:${toString config.services.prometheus.exporters.node.port}"
              "tor4.ketamin.trade:9191" # Fail2ban Exporer
              "tor1.catgirl.dog:${toString config.services.prometheus.exporters.node.port}"
              "tor1.catgirl.dog:9191" # Fail2ban Exporer
              "tor1.catgirl.dog:${toString config.services.prometheus.exporters.node.port}"
              "tor2.catgirl.dog:${toString config.services.prometheus.exporters.node.port}"
              "tor2.catgirl.dog:9191" # Fail2ban Exporer
              "10.10.10.1:${toString config.services.prometheus.exporters.smartctl.port}"
              "10.10.10.1:${toString config.services.prometheus.exporters.node.port}"
              "10.10.10.1:${toString config.services.prometheus.exporters.bird.port}"
              "10.10.10.1:${toString config.services.prometheus.exporters.redis.port}"
              "10.10.10.1:${toString config.services.prometheus.exporters.postgres.port}"
              "vps.flohannes.de:${toString config.services.prometheus.exporters.node.port}"
              "[2a0e:8f02:f017::1]:${toString config.services.prometheus.exporters.node.port}"
              "[2a0e:8f02:f017::2]:${toString config.services.prometheus.exporters.node.port}"
              "[2a0e:8f02:f017::3]:${toString config.services.prometheus.exporters.node.port}"
              "[2a0e:8f02:f017::4]:${toString config.services.prometheus.exporters.node.port}"
              "[2a0e:8f02:f017::1]:${toString config.services.prometheus.exporters.bird.port}"
              "localhost:9590"
            ];
          }
        ];
      }
    ];
  };
}
