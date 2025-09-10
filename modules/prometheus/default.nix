{
  config,
  ...
}:
{
  age.secrets.rclone = {
    file = ../../secrets/rclone.age;
    owner = "prometheus";
    group = "prometheus";
  };
  age.secrets.restic = {
    file = ../../secrets/restic.age;
    owner = "prometheus";
    group = "prometheus";
  };
  age.secrets.nextcloud-exporter = {
    file = ../../secrets/nextcloud-exporter.age;
    owner = "prometheus";
    group = "prometheus";
  };

  services.prometheus = {
    scrapeConfigs = [
      {
        job_name = "bgptools";
        scrape_interval = "300s";
        metrics_path = "/prom/1a475212-0fd1-48d2-90a9-9dde66076330";
        static_configs = [
          {
            targets = [
              "prometheus.bgp.tools:443"
            ];
          }
        ];
      }
      {
        job_name = "nodes";
        scrape_interval = "30s";
        static_configs = [
          {
            targets = [
              "10.10.1.25:${toString config.services.prometheus.exporters.node.port}"
              "10.10.1.22:17871"
              "localhost:${toString config.services.prometheus.exporters.node.port}"
              "localhost:${toString config.services.prometheus.exporters.restic.port}"
              "shit.ketamin.trade:${toString config.services.prometheus.exporters.node.port}"
              "tor1.ketamin.trade:${toString config.services.prometheus.exporters.node.port}"
              "tor1.ketamin.trade:9191" # Fail2ban Exporer
              "tor2.ketamin.trade:${toString config.services.prometheus.exporters.node.port}"
              "tor2.ketamin.trade:9191" # Fail2ban Exporer
              "tor3.ketamin.trade:${toString config.services.prometheus.exporters.node.port}"
              "tor3.ketamin.trade:9191" # Fail2ban Exporer
              "tor1.catgirl.dog:${toString config.services.prometheus.exporters.node.port}"
              "tor1.catgirl.dog:9191" # Fail2ban Exporer
              "tor1.catgirl.dog:${toString config.services.prometheus.exporters.node.port}"
              "tor2.catgirl.dog:${toString config.services.prometheus.exporters.node.port}"
              "tor2.catgirl.dog:9191" # Fail2ban Exporer
              "localhost:${toString config.services.prometheus.exporters.smartctl.port}"
              "localhost:${toString config.services.prometheus.exporters.node.port}"
              "localhost:${toString config.services.prometheus.exporters.bird.port}"
              "localhost:${toString config.services.prometheus.exporters.redis.port}"
              "localhost:${toString config.services.prometheus.exporters.postgres.port}"
              "localhost:${toString config.services.prometheus.exporters.wireguard.port}"
              "localhost:${toString config.services.prometheus.exporters.smokeping.port}"
              "dus1.as214958.net:${toString config.services.prometheus.exporters.node.port}"
              "dus1.as214958.net:${toString config.services.prometheus.exporters.bird.port}"
              "dus1.as214958.net:${toString config.services.prometheus.exporters.wireguard.port}"
              "dus1.as214958.net:${toString config.services.prometheus.exporters.smokeping.port}"
              "dus1.as214958.net:${toString config.services.prometheus.exporters.flow.port}"
              "vps.flohannes.de:${toString config.services.prometheus.exporters.node.port}"
            ];
          }
        ];
      }
    ];
    enable = true;
    port = 1312;
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9100;
      };
      restic = {
        refreshInterval = 6000;
        user = "prometheus";
        enable = true;
        repository = "rclone:smb:/Buro/backup";
        passwordFile = config.age.secrets.restic.path;
        rcloneConfigFile = config.age.secrets.rclone.path;
      };
      smartctl = {
        enable = true;
        devices = [
          "/dev/sda"
          "/dev/sdb"
        ];
      };
      bird = {
        enable = true;
      };
      postgres = {
        enable = true;
        port = 9187;
        runAsLocalSuperUser = true;
        extraFlags = [ "--auto-discover-databases" ];
      };
      redis = {
        enable = true;
        port = 9121;
        extraFlags = [ "--redis.addr=127.0.0.1:${toString config.services.mastodon.redis.port}" ];
      };
      wireguard = {
        enable = true;
        withRemoteIp = true;
      };
      smokeping = {
        enable = true;
        hosts = [
          "localhost"
          "tor1.ketamin.trade"
          "tor2.ketamin.trade"
          "tor3.ketamin.trade"
          "tor1.catgirl.dog"
          "tor2.catgirl.dog"
          "10.10.1.25"
          "1.1.1.1"
          "catgirl.dog"
          "google.com"
          "ip6.clerie.de"
          "dus1.as214958.net"
        ];
      };
    };
  };
}
