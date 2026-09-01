{
  inputs,
  ...
}:
{
  imports = [
    ../container
    inputs.determinate.nixosModules.default
  ];
}
