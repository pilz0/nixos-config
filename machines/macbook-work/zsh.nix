{
  lib,
  pkgs,
  config,
  ...
}:
{
  age.secrets = {
    work-bw-session = {
      file = ../../secrets/work-bw-session.age;
      path = "${config.home.homeDirectory}/.agenix/secrets/work-bw-session";
    };
  };

  programs.zsh.initContent = lib.mkOrder 1500 ''
    eval "$(direnv hook zsh)"
    export DOCKER_HOST="unix://$HOME/.colima/default/docker.sock"
    export BW_SESSION=$(${pkgs.coreutils}/bin/cat ${config.age.secrets.work-bw-session.path})
  '';
}
