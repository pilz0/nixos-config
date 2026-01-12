{
  services.nginx = {
    virtualHosts = {
      "grafana.pilz.foo" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://grafana.ams1.as214958.net:3001";
          proxyWebsockets = true;
        };
      };
      "jellyfin.pilz.foo" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://jellyfin.ams1.as214958.net:8096";
          proxyWebsockets = true;
        };
      };
      "flohannes.de" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:8080";
          proxyWebsockets = true;
        };
      };
      "lg.as214958.net" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:15000";
        };
      };
      "netbox.as214958.net" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://netbox.ams1.as214958.net:80";
        };
      };
    };
  };
}
