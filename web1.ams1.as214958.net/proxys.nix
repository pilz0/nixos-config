{
  ...
}:
{
  services.nginx = {
    virtualHosts = {
      "grafana.pilz.foo" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://[2a0e:8f02:f017::3]:3001";
          proxyWebsockets = true;
        };
      };
      "jellyfin.pilz.foo" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://10.10.10.2:8096";
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
      virtualHosts."lg.as214958.net" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:15000";
        };
      };
    };
  };
}
