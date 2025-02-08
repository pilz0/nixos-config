{ config, pkgs, ... }:
{
  imports = [
    "${
      fetchTarball {
        url = "https://github.com/onny/nixos-nextcloud-testumgebung/archive/fa6f062830b4bc3cedb9694c1dbf01d5fdf775ac.tar.gz";
        sha256 = "0gzd0276b8da3ykapgqks2zhsqdv4jjvbv97dsxg0hgrhb74z0fs";
      }
    }/nextcloud-extras.nix"
  ];
  age.secrets.smtpnextcloud = {
    file = ../secrets/smtp.age;
    owner = "nextcloud";
    group = "nextcloud";
  };
  age.secrets.nextcloud = {
    file = ../secrets/nextcloud.age;
    owner = "nextcloud";
    group = "nextcloud";
  };
  age.secrets.nextcloud-secrets = {
    file = ../secrets/nextcloud-secrets.age;
    owner = "nextcloud";
    group = "nextcloud";
  };
  services.nextcloud = {
    enable = true;
    configureRedis = true;
    package = pkgs.nextcloud30;
    hostName = "cloud.pilz.foo";
    appstoreEnable = true;
    autoUpdateApps.enable = true;
    database.createLocally = true;
    secretFile = config.age.secrets.nextcloud-secrets.path;
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) contacts calendar;
    };
    extraAppsEnable = true;
    # ensureUsers = {
    #   pilz = {
    #     email = "marie0@riseup.net";
    #     passwordFile = config.age.secrets.nextcloud.path;
    #   };
    # ${config.services.prometheus.exporters.nextcloud.username} = {
    #   email = "nextcloud-exporter@ketamin.trade";
    #   passwordFile = config.age.secrets.nextcloud-exporter.path;
    # };
    # };
    settings = {
      mail_smtpmode = "smtp";
      mail_smtphost = "mail.cock.li";
      mail_smtpport = 465;
      mail_smtptimeout = 30;
      mail_smtpsecure = "ssl";
      mail_smtpauth = true;
      mail_smtpname = "t3st1ng1312@cock.li";
      mail_domain = "cock.li";
      mail_from_address = "t3st1ng1312";
      #  mail_smtppassword = builtins.readFile config.age.secrets.smtpnextcloud.path; # set via secretfile
    };
    config = {
      adminpassFile = config.age.secrets.nextcloud.path;
      adminuser = "admin";
    };
    settings = {
      trustedProxies = [
        "localhost"
        "127.0.0.1"
        "[::1]"
      ];
      extraTrustedDomains = [
        "${config.services.nextcloud.hostName}"
        "localhost"
      ];
      overwriteProtocol = "https";
    };
  };

}
