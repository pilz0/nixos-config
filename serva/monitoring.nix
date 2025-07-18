{ pkgs, config, ... }:
{
  age.secrets.rclone = {
    file = ../secrets/rclone.age;
    owner = "prometheus";
    group = "prometheus";
  };
  age.secrets.restic = {
    file = ../secrets/restic.age;
    owner = "prometheus";
    group = "prometheus";
  };
  age.secrets.smtp = {
    file = ../secrets/smtp.age;
    owner = "grafana";
    group = "grafana";
  };
  age.secrets.grafana = {
    file = ../secrets/grafana.age;
    owner = "grafana";
    group = "grafana";
  };
  age.secrets.nextcloud-exporter = {
    file = ../secrets/nextcloud-exporter.age;
    owner = "prometheus";
    group = "prometheus";
  };
  age.secrets.traewelling = {
    file = ../secrets/traewelling.age;
    owner = "grafana";
    group = "grafana";
  };

  services.grafana = {
    enable = true;
    declarativePlugins = with pkgs.grafanaPlugins; [
      grafana-github-datasource
      grafana-clock-panel
      grafana-oncall-app
      grafana-piechart-panel
      yesoreyeram-infinity-datasource
    ];
    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          type = "prometheus";
          isDefault = true;
          name = "prometheus";
          url = "http://localhost:${toString config.services.prometheus.port}";
          uid = "e68e5107-0b44-4438-870c-019649e85d2b";
        }
        {
          name = "Loki";
          type = "loki";
          url = "http://127.0.0.1:4040";
          uid = "180d3e53-be75-4a6a-bb71-bdf437aec085";
        }
        {
          name = "trawelling";
          type = "yesoreyeram-infinity-datasource";
          basicAuth = false;
          basicAuthUser = "";
          isDefault = false;
          jsonData = {
            allowedHosts = [
              "traewelling.de"
              "https://traewelling.de"
            ];
            auth_method = "bearerToken";
            customHealthCheckEnabled = true;
            customHealthCheckUrl = "https://traewelling.de/api/v1/auth/user";
            global_queries = [ ];
            oauthPassThru = false;
            readOnly = false;
            apiVersion = "";
            secureJsonData = {
              bearerToken = "$__file{${toString config.age.secrets.traewelling.path}}";
            };
          };
        }
      ];
      dashboards = {
        settings = {
          providers = [
            {
              name = "My Dashboards";
              options.path = "/etc/grafana-dashboards";
            }
          ];
        };
      };
      alerting = {
        rules = {
          path = "/etc/grafana-alerts/alert.yaml"; # its way easyer to export them from the webinterface then manually rewrite them in nix
        };
        contactPoints = {
          path = "/etc/grafana-alerts/contacts.yaml";
        };
      };
    };

    settings = {
      analytics.reporting_enabled = false;
      smtp = {
        enable = true;
        enabled = true;
        user = "t3st1ng1312@cock.li";
        startTLS_policy = "MandatoryStartTLS";
        password = "$__file{${toString config.age.secrets.smtp.path}}";
        host = "mail.cock.li:465";
        from_name = config.services.grafana.settings.server.domain;
        from_address = config.services.grafana.settings.smtp.user;
      };
      server = {
        domain = "grafana.pilz.foo";
        root_url = "https://grafana.pilz.foo/";
        http_port = 3001;
        http_addr = "::1";
      };
      "auth.anonymous" = {
        enabled = true;
        org_name = "Main Org.";
        org_role = "Viewer";
      };
      security = {
        admin_password = "$__file{${toString config.age.secrets.grafana.path}}";
        admin_user = "admin";
        admin_email = "marie0@riseup.net";
      };
    };
  };
  environment.etc = {
    "grafana-dashboards/node-exporter.json" = {
      source = ../grafana-dashboards/node-exporter.json;
      group = "grafana";
      user = "grafana";
    };
    "grafana-dashboards/restic.json" = {
      source = ../grafana-dashboards/restic.json;
      group = "grafana";
      user = "grafana";
    };
    "grafana-dashboards/tor.json" = {
      source = ../grafana-dashboards/tor.json;
      group = "grafana";
      user = "grafana";
    };
    "grafana-dashboards/smartctl.json" = {
      source = ../grafana-dashboards/smartctl.json;
      group = "grafana";
      user = "grafana";
    };
    "grafana-dashboards/bird.json" = {
      source = ../grafana-dashboards/bird.json;
      group = "grafana";
      user = "grafana";
    };
    "grafana-dashboards/unpoller.json" = {
      source = ../grafana-dashboards/unpoller.json;
      group = "grafana";
      user = "grafana";
    };
    "grafana-dashboards/dn42.json" = {
      source = ../grafana-dashboards/dn42.json;
      group = "grafana";
      user = "grafana";
    };
    "grafana-dashboards/postgres.json" = {
      source = ../grafana-dashboards/postgres.json;
      group = "grafana";
      user = "grafana";
    };
    "grafana-alerts/contacts.yaml" = {
      source = ../grafana-alerts/contacts.yaml;
      group = "grafana";
      user = "grafana";
    };
    "grafana-alerts/alert.yaml" = {
      source = ../grafana-alerts/alert.yaml;
      group = "grafana";
      user = "grafana";
    };
  };

  services.prometheus = {
    scrapeConfigs = [
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
              "oob.dus1.as214958.net:${toString config.services.prometheus.exporters.node.port}"
              "oob.dus1.as214958.net:${toString config.services.prometheus.exporters.bird.port}"
              "oob.dus1.as214958.net:${toString config.services.prometheus.exporters.wireguard.port}"
              "oob.dus1.as214958.net:${toString config.services.prometheus.exporters.smokeping.port}"
            ];

          }
        ];
      }
      {
        job_name = "unifi";
        scrape_interval = "30s";
        static_configs = [
          {
            targets = [ "localhost:9130" ];

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
