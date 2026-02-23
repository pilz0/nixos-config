{
 config,
 lib,
 ...
}:
let
  cfg = config.pilz.services.pve-container.network;
in
{
  options.pilz.services.pve-container.network = {
    enable = lib.mkEnableOption;
    ipv4.gateway = lib.mkOption {
      type = lib.types.str;
      default = "10.10.10.1";
    };
    ipv6.gateway = lib.mkOption {
        type = lib.types.str;
        default = "2a0e:8f02:f017::1";
    };
  };
config = lib.mkIf cfg.enable {
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
            Gateway = cfg.ipv4.gateway;
            Destination = "0.0.0.0/0";
            GatewayOnLink = true;
          }
          {
            Gateway = cfg.ipv6.gateway;
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
        IPv4Forwarding = lib.mkDefault false;
        IPv6Forwarding = lib.mkDefault false;
      };
    };
    wait-online = {
      enable = false;
      anyInterface = false;
    };
  };
};
}
