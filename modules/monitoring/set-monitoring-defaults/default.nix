{
  config,
  lib,
  ...
}:
let
  cfg = config.pilz.monitoring.servers;
in
{
  options.pilz.monitoring.servers = {
    v6 = lib.mkOption {
      type = lib.types.str;
      default = "2a0e:8f02:f017::3,2a0f:be01:0:100::a3";
    };
    v4 = lib.mkOption {
      type = lib.types.str;
      default = "94.142.240.36,45.150.123.15";
    };
  };
}
