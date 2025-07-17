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
    "as214958_web/index.html" = {
      source = ./as214958_web/index.html;
      group = "nginx";
      user = "nginx";
    };
    "as214958_web/peering.html" = {
      source = ./as214958_web/peering.html;
      group = "nginx";
      user = "nginx";
    };
    "as214958_web/robots.txt" = {
      source = ./as214958_web/robots.txt;
      group = "nginx";
      user = "nginx";
    };
  };
}
