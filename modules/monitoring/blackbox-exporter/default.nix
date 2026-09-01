{
  config,
  lib,
  ...
}:
{
  options.pilz.monitoring.blackbox-anodyne.enable = lib.mkEnableOption "";

  config = lib.mkIf config.pilz.monitoring.blackbox-anodyne.enable {

    services.prometheus = {
      exporters = {
        blackbox = {
          enable = true;
          listenAddress = "[::]";
          configFile = builtins.toFile "blackbox-config" ''
            modules:
              anodyne-probe:
                prober: http
                timeout: 10s
                http:
                  method: GET
                  fail_if_not_ssl: true
                  fail_if_body_not_matches_regexp:
                    - "Welcome to AnodyneWiki"
                  headers:
                    User-Agent: "blackbox-exporter (AS214958; contact: noc@as214958.net)"        
          '';
        };
      };
    };
  };
}
