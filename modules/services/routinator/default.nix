{
  config,
  lib,
  ...
}:
let
  cfg = config.pilz.services.routinator;
in
{
  options.pilz.services.routinator = {
    enable = lib.mkEnableOption "enable routinator configuration";
    listenAddresses = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "0.0.0.0:3323"
        "[2a0e:8f02:f017::5]:3323"
      ];
    };
  };
  config = lib.mkIf cfg.enable {
    services.routinator = {
      enable = cfg.enable;
      settings = {
        enable-aspa = true;
        rtr-listen = cfg.listenAddresses;
      };
    };
  };
}
