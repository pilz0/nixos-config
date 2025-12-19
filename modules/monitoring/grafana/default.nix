{
  config,
  pkgs,
  ...
}:
let
  grafanaPlugin = pkgs.callPackage (
    pkgs.path + "/pkgs/servers/monitoring/grafana/plugins/grafana-plugin.nix"
  ) { };
  netsage-sankey-panel = pkgs.callPackage ../../../custom_pkgs/netsage-sankey-panel.nix {
    inherit grafanaPlugin;
  };
in
{

  age.secrets = {
    smtp = {
      file = ../../../secrets/smtp.age;
      owner = "grafana";
      group = "grafana";
    };
    grafana = {
      file = ../../../secrets/grafana.age;
      owner = "grafana";
      group = "grafana";
    };
  };
  environment.etc = {
    "grafana-alerts" = {
      source = ./grafana-alerts;
      group = "grafana";
      user = "grafana";
    };
    "grafana-dashboards" = {
      source = ./grafana-dashboards;
      group = "grafana";
      user = "grafana";
    };
  };

  services = {
    grafana = {
      enable = true;
      declarativePlugins = with pkgs.grafanaPlugins; [
        grafana-github-datasource
        grafana-clock-panel
        grafana-oncall-app
        grafana-piechart-panel
        grafana-polystat-panel
        netsage-sankey-panel
        yesoreyeram-infinity-datasource
      ];
      provision = {
        enable = true;
        datasources = {
          settings = {
            datasources = [
              {
                type = "prometheus";
                isDefault = true;
                name = "prometheus";
                url = "http://localhost:${toString config.services.prometheus.port}";
                uid = "e68e5107-0b44-4438-870c-019649e85d2b";
              }
              {
                type = "loki";
                name = "Loki";
                url = "http://localhost:${toString config.services.loki.configuration.server.http_listen_port}";
                uid = "5e20af34-8d96-4035-9830-19a7e3cbb200";
              }
            ];
          };
        };
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
        analytics = {
          reporting_enabled = false;
        };
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
          http_addr = "";
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
  };
}
