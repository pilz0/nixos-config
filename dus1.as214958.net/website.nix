{ ... }:
{
  services.nginx = {
    virtualHosts."as214958.net" = {
      enableACME = true;
      forceSSL = true;
      root = "/etc/as214958_web/";
    };
  };
  environment.etc = {
    "as214958_web" = {
      source = ./as214958_web;
      group = "nginx";
      user = "nginx";
    };
  };
}
