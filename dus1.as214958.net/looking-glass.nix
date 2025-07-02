{
  ...
}:
{
  services.bird-lg = {
    proxy = {
      enable = true;
      listenAddress = "[2a0c:b640:10::2:44]:18000";
      allowedIPs = [ "::0/0" ];
    };
    frontend = {
      domain = "lg.as214958.net";
      enable = true;
      servers = [ "dus1" ];
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
}
