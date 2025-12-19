{
  services = {
    bird-lg = {
      frontend = {
        domain = "lg.as214958.net";
        enable = true;
        servers = [
          "ams1"
          "dn42"
        ];
        protocolFilter = [
          "bgp"
          "static"
        ];
        listenAddresses = [ "[::1]:15000" ];
        proxyPort = 18000;
        navbar = {
          brand = "as214958";
        };
      };
    };
  };
}
