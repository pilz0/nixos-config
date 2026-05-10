{
  config,
  lib,
  ...
}:
let
  cfg = config.pilz.services.birdLg.frontend;
in
{
  options.pilz.services.birdLg.frontend = {
    enable = lib.mkEnableOption "enable bird-lg-frontend configuration";
    domain = lib.mkOption {
      type = lib.types.str;
      default = "lg.as214958.net";
    };
    servers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "ams1"
        "dn42"
      ];
    };
    listenAddresses = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "[::1]:15000" ];
    };
    proxyPort = lib.mkOption {
      type = lib.types.int;
      default = 18000;
    };
  };
  config = lib.mkIf cfg.enable {
    services = {
      bird-lg = {
        frontend = {
          domain = cfg.domain;
          enable = true;
          servers = cfg.servers;
          protocolFilter = [
            "bgp"
            "static"
          ];
          listenAddresses = cfg.listenAddresses;
          proxyPort = cfg.proxyPort;
          navbar = {
            brand = "as214958";
          };
        };
      };
    };
  };
}
