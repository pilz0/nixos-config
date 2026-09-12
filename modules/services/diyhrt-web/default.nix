{
  config,
  lib,
  ...
}:
let
  cfg = config.pilz.services.diyhrt-web;
in
{
  options.pilz.services.diyhrt-web = {
    enable = lib.mkEnableOption "Enable hrt.pilz.foo website";
    domain = lib.mkOption {
      type = lib.types.str;
      default = "hrt.pilz.foo";
    };
  };
  config = lib.mkIf cfg.enable {
    services.nginx = {
      enable = true;
      virtualHosts.${cfg.domain} = {
        enableACME = true;
        forceSSL = true;
        root = "/etc/diyhrt-web/";
      };
    };
    environment.etc = {
      "diyhrt-web" = {
        source = ./webroot;
        group = config.services.nginx.group;
        user = config.services.nginx.user;
      };
    };
  };
}
