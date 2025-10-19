{
  config,
  pkgs,
  ...
}:
{
  age.secrets.netbox = {
    file = ../../secrets/netbox.age;
    owner = "netbox";
    group = "netbox";
  };
  services.netbox = {
    package = pkgs.netbox_4_2;
    enable = true;
    secretKeyFile = config.age.secrets.netbox.path;
  };
  services.nginx = {
    enable = true;
    user = "netbox";
    recommendedTlsSettings = true;
    clientMaxBodySize = "25m";
    virtualHosts."${config.networking.fqdn}" = {
      locations = {
        "/" = {
          proxyPass = "http://[::1]:8001";
        };
        "/static/" = {
          alias = "${config.services.netbox.dataDir}/static/";
        };
      };
    };
  };
}
