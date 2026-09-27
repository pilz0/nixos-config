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
              http-2xx:
                prober: http
                timeout: 10s
                http:
                  method: GET
                  fail_if_not_ssl: true
                  valid_status_codes: []
                  headers:
                    User-Agent: "blackbox-exporter (AS214958; contact: noc@as214958.net)"
              icmp:
                prober: icmp
                timeout: 10s
                icmp:
          '';
        };
      };
    };
  };
}
