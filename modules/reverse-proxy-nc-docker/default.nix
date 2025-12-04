{
  config,
  ...
}:
{
  services.nginx = {
    virtualHosts."cloud2.pilz.foo" = {
      sslCertificate = config.age.secrets.cloudflare_cert.path;
      sslCertificateKey = config.age.secrets.cloudflare_key.path;
      locations."/" = {
        proxyPass = "http://10.10.1.22:1100";
      };
    };
  };
}
