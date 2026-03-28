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
    dir = lib.mkOption {
      type = lib.types.str;
      default = "/srv/";
    };
    wgConfSecretFile = lib.mkOption {
      type = lib.types.path;
      default = ../../../secrets/nixarr-wg.age;
    };
    peerPort = lib.mkOption {
      type = lib.types.int;
      default = 63993;
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets.nixarr-wg = {
      file = cfg.wgConfSecretFile;
      #owner = "nixarr";
      #group = "nixarr";
    };

    nixarr = {
      enable = true;
      mediaDir = cfg.dir;
      stateDir = "${cfg.dir}.state/nixarr";

      vpn = {
        enable = true;
        wgConf = config.age.secrets.nixarr-wg.path;
      };

      transmission = {
        enable = true;
        vpn.enable = true;
        peerPort = cfg.peerPort;
        extraSettings = {
          peer-limit-global = 1500;
          speed_limit_up = 24000; # 192mbit
          speed_limit_up_enabled = true;
          upload_slots_per_torrent = 200;
          peer_limit_per_torrent  = 300;
        };
      };
    };

    services = {
      jellyfin = {
        enable = true;
      };
      jellyseerr = {
        enable = false;
      };
    };
  };
}
