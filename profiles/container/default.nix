{
  inputs,
  ...
}:
{
  imports = [
    ../../modules/container
    ../../modules/container/network.nix
    ../../modules/common
    inputs.determinate.nixosModules.default
  ];
}
