{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.pilz.networking.tor-relay;
in
{
  options.pilz.networking.tor-relay = {
    enable = lib.mkEnableOption "";
    prometheusServer = lib.mkOption {
      type = lib.types.string;
      default = "2a0e:8f02:f017::3";
    };
    eth0 = {
      address = lib.mkOption {
        type = lib.types.listOf lib.types.string;
      };
      gateway = lib.mkOption {
        type = lib.types.string;
        default = "2a0e:8f02:f017::1";
      };
    };
    eth1 = {
      address = lib.mkOption {
        type = lib.types.listOf lib.types.string;
      };
      gateway = lib.mkOption {
        type = lib.types.string;
        default = "10.0.0.1";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    networking.firewall = {
      extraCommands = ''
        ${pkgs.iptables}/bin/ip6tables -A INPUT -p tcp --dport 9052 -s ${toString cfg.prometheusServer} -j ACCEPT
      '';
    };
    systemd.network = {
      enable = true;
      networks = {
        "10-eth0" = {
          address = cfg.eth0.address;
          networkConfig = {
            IPv6AcceptRA = true;
          };
          matchConfig.Name = "eth0";
          routes = [
            {
              Gateway = cfg.eth0.gateway;
              Destination = "::/0";
            }
          ];
          linkConfig.RequiredForOnline = "routable";
        };
        "20-eth1" = {
          address = cfg.eth1.address;
          matchConfig.Name = "eth1";
          routes = [
            {
              Gateway = cfg.eth1.gateway;
              Destination = "0.0.0.0/0";
              GatewayOnLink = true;
            }
          ];
          linkConfig.RequiredForOnline = "routable";
        };
      };
    };
  };
}
