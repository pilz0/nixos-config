{
  ...
}:
{
  security.acme = {
    acceptTerms = true;
    defaults.email = "acme@as214958.net";
  };

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."lg.as214958.net" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://[::1]:15000";
      };
    };
  };
}
