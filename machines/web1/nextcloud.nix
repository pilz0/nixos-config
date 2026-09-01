{
  config,
  pkgs,
  ...
}:
{
  environment.etc."nextcloud-admin-pass".text = "S4uhdNRVZntUns";
  services.nextcloud = {
    package = pkgs.nextcloud33;
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
}
