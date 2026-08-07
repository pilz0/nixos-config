{
  inputs,
  ...
}:
{
  imports = [
    ../../modules/darwin/colima
    ../../modules/darwin/pkgs
    inputs.determinate.darwinModules.default
  ];
}
