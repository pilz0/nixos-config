{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.pilz.services.grafana;
  grafanaPlugin = pkgs.callPackage (
    pkgs.path + "/pkgs/servers/monitoring/grafana/plugins/grafana-plugin.nix"
  ) { };
  netsage-sankey-panel = pkgs.callPackage ../../../pkgs/netsage-sankey-panel.nix {
    inherit grafanaPlugin;
  };
in
{
  options.pilz.services.grafana = {
    enable = lib.mkEnableOption "Enable Grafana";
    domain = lib.mkOption {
      type = lib.types.str;
      default = "grafana.pilz.foo";
    };
    port = lib.mkOption {
      type = lib.types.int;
      default = 3001;
    };
    prometheus.url = lib.mkOption {
      type = lib.types.str;
      default = "http://localhost:${toString config.services.prometheus.port}";
    };
    loki.url = lib.mkOption {
      type = lib.types.str;
      default = "http://localhost:3100";
    };
    adminPassword = lib.mkOption {
      type = lib.types.str;
      default = "$__file{${toString config.age.secrets.grafana.path}}";
    };
    smtp = {
      email = lib.mkOption {
        type = lib.types.str;
        default = "t3st1ng1312@cock.li";
      };
      password = lib.mkOption {
        type = lib.types.str;
        default = "$__file{${toString config.age.secrets.smtp.path}}";
      };
      host = lib.mkOption {
        type = lib.types.str;
        default = "mail.cock.li:465";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    environment.etc = {
      "grafana-alerts" = {
        source = ./alerts;
        group = "grafana";
        user = "grafana";
      };
      "grafana-dashboards" = {
        source = ./dashboards;
        group = "grafana";
        user = "grafana";
      };
    };

    services = {
      grafana = {
        enable = cfg.enable;
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
                  url = cfg.prometheus.url;
                  uid = "e68e5107-0b44-4438-870c-019649e85d2b";
                }
                {
                  type = "loki";
                  name = "Loki";
                  url = cfg.loki.url;
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
            user = cfg.smtp.email;
            startTLS_policy = "MandatoryStartTLS";
            password = cfg.smtp.password;
            host = cfg.smtp.host;
            from_name = config.services.grafana.settings.server.domain;
            from_address = config.services.grafana.settings.smtp.user;
          };
          server = {
            domain = cfg.domain;
            root_url = "https://${cfg.domain}/";
            http_port = cfg.port;
            http_addr = "";
          };
          "auth.anonymous" = {
            enabled = true;
            org_name = "Main Org.";
            org_role = "Viewer";
          };
          security = {
            admin_password = cfg.adminPassword;
            admin_user = "admin";
            admin_email = "marie0@riseup.net";
          };
        };
      };
    };
  };
}
