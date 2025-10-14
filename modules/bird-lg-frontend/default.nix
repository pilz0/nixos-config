{
  ...
}:
{
  services = {
    bird-lg = {
      frontend = {
        domain = "lg.as214958.net";
        enable = true;
        servers = [ "ams1.as214958.net" ];
        protocolFilter = [
          "bgp"
          "static"
        ];
        listenAddress = "[::1]:15000";
        proxyPort = 18000;
        navbar = {
          brand = "as214958";
        };
      };
    };
  };
}
