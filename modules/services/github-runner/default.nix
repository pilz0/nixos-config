{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
let
  cfg = config.pilz.services.github-runner;
in
{
  options.pilz.services.github-runner = {
    enable = lib.mkEnableOption "";
    runners = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
  };
  config = lib.mkIf cfg.enable {
    users = {
      users.github-runner = {
        group = "github-runner";
        isSystemUser = true;
      };
      groups.github-runner = { };
    };

    services = {
      github-runners = cfg.runners;
    };
  };
}
