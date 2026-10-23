{
  config,
  lib,
  ...
}:
let
  cfg = config.pilz.services.jira;
in
{
  options.pilz.services.jira = {
    enable = lib.mkEnableOption "jira (atlassian has been removed from nixpkgs, so this runs the upstream oci image)";
    domain = lib.mkOption {
      type = lib.types.nonEmptyStr;
      default = "jira.pilz.foo";
    };
    image = lib.mkOption {
      type = lib.types.nonEmptyStr;
      default = "docker.io/atlassian/jira-software:10.3";
    };
    crackJar = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to a cracked atlassian-extras jar to bind-mount into the container";
    };
  };
  config = lib.mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      ensureDatabases = [ "jira" ];
      ensureUsers = [
        {
          name = "jira";
          ensureDBOwnership = true;
        }
      ];
      # the container uses host networking and can't use the unix socket via jdbc
      authentication = lib.mkBefore ''
        host jira jira 127.0.0.1/32 trust
      '';
    };

    virtualisation.oci-containers = {
      backend = "podman";
      containers.jira = {
        inherit (cfg) image;
        volumes = [
          "/var/lib/jira:/var/atlassian/application-data/jira"
        ]
        ++ lib.optionals (cfg.crackJar != null) [
          "${cfg.crackJar}:/opt/atlassian/jira/atlassian-jira/WEB-INF/lib/atlassian-extras-3.4.6.jar:ro"
        ];
        extraOptions = [ "--network=host" ];
        environment = {
          ATL_PROXY_NAME = cfg.domain;
          ATL_PROXY_PORT = "443";
          ATL_TOMCAT_SCHEME = "https";
          ATL_TOMCAT_SECURE = "true";
          ATL_DB_TYPE = "postgres72";
          ATL_DB_DRIVER = "org.postgresql.Driver";
          ATL_JDBC_URL = "jdbc:postgresql://127.0.0.1:5432/jira";
          ATL_JDBC_USER = "jira";
          ATL_JDBC_PASSWORD = "";
          JVM_MINIMUM_MEMORY = "2048m";
          JVM_MAXIMUM_MEMORY = "4096m";
        };
      };
    };
    systemd.services.podman-jira = {
      after = [ "postgresql.service" ];
      requires = [ "postgresql.service" ];
    };

    # uid/gid 2001 is the jira user inside the image
    systemd.tmpfiles.rules = [ "d /var/lib/jira 0750 2001 2001 -" ];
  };
}
