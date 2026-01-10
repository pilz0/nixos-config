{
  config,
  ...
}:
{
  services.promtail = {
    enable = true;
    configuration = {
      server = {
        http_listen_port = 9080;
      };
      clients = [
        {
          url = "http://loki.as214958.net:3100/loki/api/v1/push";
        }
      ];
      positions = {
        filename = "/tmp/positions.yaml";
      };
      scrape_configs = [
        {
          job_name = "journal";
          journal = {
            max_age = "12h";
            labels = {
              job = "systemd-journal";
              host = config.networking.fqdn;
            };
          };
          relabel_configs = [
            {
              source_labels = [ "__journal__systemd_unit" ];
              target_label = "unit";
            }
          ];
        }
      ];
    };
  };
}
