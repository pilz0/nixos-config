{
  config,
  ...
}:
let
  cfg = config.pilz.services.opensearchDashboard;
in
{
  options.pilz.services.opensearchDashboard = {
    enable = lib.mkEnableOption;
    server = {
      host = lib.mkOption {
        type = lib.types.str;
        default = "http://localhost:9200";
      };
      
    };
  };
  environment.etc.opensearch = {
    text = ''
      server.name: opensearch_dashboards
      server.host: ${cfg.server.host}
      server.customResponseHeaders : { "Access-Control-Allow-Credentials" : "true" }

      # Disabling HTTPS on OpenSearch Dashboards
      server.ssl.enabled: false

      opensearch.ssl.verificationMode: none
      opensearch.username: kibanaserver
      opensearch.password: kibanaserver
      opensearch.requestHeadersWhitelist: ["securitytenant","Authorization"]

      # Multitenancy
      opensearch_security.multitenancy.enabled: true
      opensearch_security.multitenancy.tenants.preferred: ["Private", "Global"]
      opensearch_security.readonly_mode.roles: ["kibana_read_only"]
    '';
  };
  virtualisation.oci-containers.containers = {
    opensearch-dashboard = {
      image = "opensearchproject/opensearch-dashboards:latest";
      ports = [ "127.0.0.1:5601:5601" ];
      volumes = [
        "/etc/opensearch:/usr/share/opensearch-dashboards/config/opensearch_dashboards.yml"
      ];
    };
  };
  networking.firewall.allowedTCPPorts = [
    9200
    5601
  ];
}
