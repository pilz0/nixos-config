{
  config,
  ...
}:
{
  imports = [
    ../../modules/darwin/shell
  ];
  home.stateVersion = "25.11";
  age.identityPaths = [ "${config.home.homeDirectory}/.ssh/work_ssh" ];
}
