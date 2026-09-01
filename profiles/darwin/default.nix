{
  inputs,
  ...
}:
{
  imports = [
    inputs.determinate.darwinModules.default
    ../../modules/darwin/colima
    ../../modules/darwin/pkgs
    #    ../../modules/darwin/shell homemanager
  ];
  pilz.darwin.services.colima.enable = true;
  pilz.darwin.pkgs.enable = true;
  pilz.darwin.shell = true;
}
