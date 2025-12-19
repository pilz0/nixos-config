{
  config,
  pkgs,
  ...
}:
{
  age.secrets.netbox = {
    file = ../../../secrets/netbox.age;
    owner = "netbox";
    group = "netbox";
  };
  services.netbox = {
    package = pkgs.netbox_4_3;
    enable = true;
    secretKeyFile = config.age.secrets.netbox.path;
  };
  nixpkgs.config.permittedInsecurePackages = [
    "netbox-4.3.7"
  ];
  services.nginx = {
    enable = true;
    user = "netbox";
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
