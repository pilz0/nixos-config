{
  systemd.network = {
    enable = true;
    networks = {
      "10-eth0" = {
        networkConfig = {
          IPv6AcceptRA = true;
        };
        matchConfig.Name = "eth0";
        routes = [
          {
            Gateway = "2a0e:8f02:f017::1";
            Destination = "::/0";
          }
        ];
        linkConfig.RequiredForOnline = "routable";
      };
      "20-eth1" = {
        matchConfig.Name = "eth1";
        routes = [
          {
            Gateway = "10.0.0.1";
            Destination = "0.0.0.0/0";
            GatewayOnLink = true;
          }
        ];
        linkConfig.RequiredForOnline = "routable";
      };
    };
  };
}
