{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.nix-rosetta-builder.darwinModules.default
  ];
  # enable on setup for rosetta builder
  #
  # nix.linux-builder.enable = true;
  nix-rosetta-builder = {
    onDemand = true;
    onDemandLingerMinutes = 60;
    cores = 8;
    jobs = 8;
    memory = "32GiB";
  };
}
