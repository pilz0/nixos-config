{
  ...
}:
{
  services.bird-lg = {
    proxy = {
      enable = true;
      listenAddress = "[::1]:18000";
      allowedIPs = [ "::0/0" ];
    };
    frontend = {
      domain = "lg.as214958.net";
      enable = true;
      servers = [ "dus1_local" ];
      protocolFilter = [
        "bgp"
        "static"
      ];
      listenAddress = "[::1]:15000";
      proxyPort = 18000;
      navbar = {
        brand = "as214958.net";
      };
    };
  };
  services.nginx = {
    virtualHosts."lg.as214958.net" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://[::1]:15000";
      };
    };
  };
}
