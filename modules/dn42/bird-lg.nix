{
  config,
  ...
}:
{
  services.bird-lg = {
    proxy = {
      enable = true;
      listenAddress = "172.22.179.129:18000";
      allowedIPs = [ "172.0.0.0/8" ];
    };
    frontend = {
      domain = "lg.pilz.foo";
      enable = true;
      servers = [ "serva" ];
      protocolFilter = [
        "bgp"
        "static"
      ];
      listenAddress = "[::1]:15000";
      proxyPort = 18000;
      navbar = {
        brand = "cybertrash";
      };
    };
  };

  services.nginx = {
    virtualHosts."lg.pilz.foo" = {
      sslCertificate = config.age.secrets.cloudflare_cert.path;
      sslCertificateKey = config.age.secrets.cloudflare_key.path;
      locations."/" = {
        proxyPass = "http://localhost:15000";
      };
    };
  };
}
