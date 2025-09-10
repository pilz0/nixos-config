{
  ...
}:
{
  services.nginx = {
    virtualHosts."cloud2.pilz.foo" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://172.22.179.129:1100";
      };
    };
  };
}
