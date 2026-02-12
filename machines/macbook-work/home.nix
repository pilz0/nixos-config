{
  inputs,
  config,
  ...
}:
{
  imports = [
    ../../modules/darwin/shell
    ./zsh.nix
  ];
  home.stateVersion = "25.11";
  age.identityPaths = ["${config.home.homeDirectory}/.ssh/work_ssh"];
}
