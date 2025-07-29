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
  };
}
