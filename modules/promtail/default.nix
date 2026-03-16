{
  config,
  lib,
  ...
}:
let
  cfg = config.pilz.services.promtail;
in
{
  options.pilz.services.promtail = {
    enable = lib.mkEnableOption "enable promtail configuration";
    httpPort = lib.mkOption {
      type = lib.types.int;
      default = 9080;
    };
    clients = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = [ { url = "http://loki.as214958.net:3100/loki/api/v1/push"; } ];
    };
  };
  config = lib.mkIf cfg.enable {
    services.promtail = {
      enable = cfg.enable;
      configuration = {
        server = {
          http_listen_port = cfg.httpPort;
        };
        clients = cfg.clients;
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
  };
}
