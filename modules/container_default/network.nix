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
            Gateway = "10.10.10.1";
            Destination = "0.0.0.0/0";
            GatewayOnLink = true;
          }
          {
            Gateway = "2a0e:8f02:f017::1";
            Destination = "::/0";
          }
        ];
        linkConfig.RequiredForOnline = "routable";
      };
    };
    config = {
      networkConfig = {
        # https://github.com/systemd/systemd/issues/36347
        ManageForeignRoutes = false;
        ManageForeignRoutingPolicyRules = false;
        IPv4Forwarding = true;
        IPv6Forwarding = true;
      };
    };
    wait-online = {
      enable = false;
      anyInterface = false;
    };
  };
}
