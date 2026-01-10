{ pkgs, config, ... }:
{
  age.secrets = {
    forgejo-runner-token = {
      file = ../../../secrets/forgejo-runner-token.age;
      owner = "gitea-runner";
      group = "users";
    };
  };
  users.users.gitea-runner.extraGroups = [ "docker" ];
  users.users.gitea-runner.group = "gitea-runner";
  users.groups.gitea-runner = { };
  users.users.gitea-runner.isSystemUser = true;

  services.gitea-actions-runner = {
    package = pkgs.forgejo-runner;
    instances.default = {
      enable = true;
      name = "as214958-build";
      url = "https://woof.rip";
      tokenFile = config.age.secrets.forgejo-runner-token.path;
      labels = [
        "ubuntu-latest:docker://node:24.12.0-trixie"
        "ubuntu-24.04:docker://node:24.12.0-trixie"
      ];
    };
  };
}
