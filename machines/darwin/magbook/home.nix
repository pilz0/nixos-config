{
  inputs,
  ...
}:
{
  imports = [
    ../../../modules/darwin/shell
  ];
  pilz.darwin.shell.enable = true;
  home.stateVersion = "25.11";
}
