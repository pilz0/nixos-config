{
  config,
}:
let
  cfg = config.pilz.services.opensearch;
in
{
  options.pilz.services.opensearch = {
    enable = lib.mkEnableOption "";
    clusterName = lib.mkOption {
      type = lib.types.str;
      default = "test-cluster";
    };
    httpPort = lib.mkOption {
      type = lib.types.int;
      default = 9200;
    };
    transportPort = lib.mkOption {
      type = lib.types.int;
      default = 9300;
    };
    disableSecurity = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    nodeName = lib.mkOption {
      type = lib.types.str;
      default = "opensearch-node-1";
    };
    networkHost = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
    };
    discoveryType = lib.mkOption {
      type = lib.types.str;
      default = "single-node";
    };
  };
  config = lib.mkIf cfg.enable {
    services.opensearch = {
      enable = cfg.enable;
      settings = {
        "cluster.name" = cfg.clusterName;
        "http.port" = cfg.httpPort;
        "transport.port" = cfg.transportPort;
        "node.name" = cfg.nodeName;
        "network.host" = cfg.networkHost;
        "discovery.type" = cfg.discoveryType;
        "plugins.security.disabled" = cfg.disableSecurity;
      };
    };
  };
}
