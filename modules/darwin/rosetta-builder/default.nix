{
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.nix-rosetta-builder.darwinModules.default
  ];
  # enable on setup for rosetta builder

  # nix.linux-builder.enable = true;
  nix-rosetta-builder = {
    onDemand = lib.mkDefault true;
    onDemandLingerMinutes = lib.mkDefault 60;
    cores = lib.mkDefault 8;
    jobs = lib.mkDefault 8;
    memory = lib.mkDefault "16GiB";
  };
}
