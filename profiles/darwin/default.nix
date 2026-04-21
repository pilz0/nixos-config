{
  inputs,
  ...
}:
{
  imports = [
    ../../modules/darwin/colima
    ../../modules/darwin/pkgs
    ../../modules/darwin/rosetta-builder
    inputs.determinate.darwinModules.default
  ];
}
