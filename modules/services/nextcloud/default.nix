{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.pilz.services.nextcloud = {
    enable = lib.mkEnableOption "";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.nextcloud34;
    };
    domain = lib.mkOption {
      type = lib.types.str;
      default = "cloud.freifick.net";
    };
  };

  config = lib.mkIf config.pilz.services.nextcloud.enable {

    environment.etc."nextcloud-admin-pass".text = "S4uhdNRVZntUns";

    services.nextcloud = {
      package = pkgs.nextcloud34;
      enable = true;
      hostName = "cloud.freifick.net";
      config.adminpassFile = "/etc/nextcloud-admin-pass";
      config.dbtype = "sqlite";
      settings = {
        maintenance_window_start = 1;
        default_phone_region = "DE";
        log_type = "systemd";
        serverid = 0;
      };
    };

    services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
      forceSSL = true;
      enableACME = true;
    };
  };
}
