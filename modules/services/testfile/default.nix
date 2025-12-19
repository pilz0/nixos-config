{
  systemd.tmpfiles.rules = [
    "d /var/www/cache/testfile 0755 nginx nginx -"
    "d /var/www/cache/testfile 0755 nginx nginx -"
  ];

  services = {
    nginx = {
      virtualHosts = {
        "testfile.as214958.net" = {
          enableACME = true;
          forceSSL = true;
          root = "/var/www/cache/testfile";
          extraConfig = "autoindex on;";
        };
      };
    };
  };
}
