{
  inputs,
  lib,
  ...
}:
let
  cfg = config.pilz.services.darwin.rosetta-builder;
in
{
  imports = [
    inputs.nix-rosetta-builder.darwinModules.default
  ];
    options.pilz.services.darwin.rosetta-builder = {
    memory = lib.mkOption {
      type = lib.types.int;
      default = 16;
    };
    cores = lib.mkOption {
      type = lib.types.int;
      default = 8;
    };
    jobs = lib.mkOption {
      type = lib.types.int;
      default = 8;
    };
  };
config = {
  # enable on setup for rosetta builder
  # nix.linux-builder.enable = true;
  nix-rosetta-builder = {
    onDemand =  true;
    onDemandLingerMinutes = 60;
    cores = cfg.cores;
    jobs = cfg.jobs;
    memory = "${cfg.memory}GiB";
  };
};
}
