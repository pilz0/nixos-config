{
  config,
  lib,
  ...
}:
let
  cfg = config.pilz.services.as214958Net;
in
{
  options.pilz.services.as214958Net = {
    enable = lib.mkEnableOption "Enable as214958.net website";
    domain = lib.mkOption {
      type = lib.types.str;
      default = "as214958.net";
    };
  };
  config = lib.mkIf cfg.enable {
    services.nginx = {
      enable = true;
      virtualHosts.${cfg.domain} = {
        enableACME = true;
        forceSSL = true;
        root = "/etc/as214958_web/";
      };
    };
    environment.etc = {
      "as214958_web" = {
        source = ./webroot;
        group = config.services.nginx.group;
        user = config.services.nginx.user;
      };
    };
  };
}
