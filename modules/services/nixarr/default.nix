{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.pilz.services.nixarr;
in
{
  imports = [
    inputs.nixarr.nixosModules.default
  ];

  options.pilz.services.nixarr = {
    enable = lib.mkEnableOption "enable nixarr configuration";
    mediaDir = lib.mkOption {
      type = lib.types.str;
      default = "/srv/";
    };
    stateDir = lib.mkOption {
      type = lib.types.str;
      default = "/srv/media/.state/nixarr";
    };
    wgConfSecretFile = lib.mkOption {
      type = lib.types.path;
      default = ../../../secrets/nixarr-wg.age;
    };
    peerPort = lib.mkOption {
      type = lib.types.int;
      default = 63993;
    };
    monitoring-servers-v4 = lib.mkOption {
      type = lib.types.str;
      default = "94.142.240.36";
    };
    monitoring-servers-v6 = lib.mkOption {
      type = lib.types.str;
      default = "2a0e:8f02:f017::3";
    };
  };

  config = lib.mkIf cfg.enable {

    age.secrets.nixarr-wg = {
      file = cfg.wgConfSecretFile;
    };

    systemd.tmpfiles.rules = [
      "d /srv/ 0777 jellyfin jellyfin -"
      "d /srv/media/ 0755 jellyfin jellyfin -"
    ];

    nixarr = {
      enable = true;
      inherit (cfg) mediaDir;
      inherit (cfg) stateDir;

      vpn = {
        enable = true;
        wgConf = config.age.secrets.nixarr-wg.path;
      };

      exporters.enable = true;

      transmission = {
        enable = true;
        vpn.enable = true;
        inherit (cfg) peerPort;
        extraSettings = {
          peer-limit-global = 1500;
          speed-limit-up = 37500; # 300mbit
          speed-limit-up-enabled = true;
          upload-slots-per-torrent = 200;
          peer-limit-per-torrent = 300;
        };
      };
    };

    services = {
      jellyfin = {
        enable = true;
      };
    };
    networking.firewall.extraCommands = ''
      iptables -I nixos-fw -p tcp -s ${cfg.monitoring-servers-v4} -m tcp --dport 9586 -j nixos-fw-accept
      ip6tables -I nixos-fw -p tcp -s ${cfg.monitoring-servers-v6} -m tcp --dport 9586 -j nixos-fw-accept
    '';
  };
}
