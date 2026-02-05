{
  lib,
  ...
}:
{
  #age.secrets = {
  # smtp = {
  #   file = ../../../secrets/work-bw-session.age;
  #   owner = "pilz";
  #   group = "pilz";
  #   };
  # };
  programs.zsh.initContent = lib.mkOrder 1500 ''
    eval "$(direnv hook zsh)"
    export DOCKER_HOST="unix://$HOME/.colima/default/docker.sock"
  '';
}
