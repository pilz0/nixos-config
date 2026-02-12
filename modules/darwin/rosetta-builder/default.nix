{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.nix-rosetta-builder.darwinModules.default
  ];
  # enable on setup for rosetta builder
  # nix.linux-builder.enable = true;
  nix-rosetta-builder = {
    onDemand = true;
    onDemandLingerMinutes = 60;
    cores = lib.mkDefault 8;
    jobs = config.nix-rosetta-builder.cores;
    memory = lib.mkDefault "16GiB";
  };
}
