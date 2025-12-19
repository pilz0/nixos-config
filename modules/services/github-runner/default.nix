{
  config,
  ...
}:
{
  virtualisation.docker.enable = true;
  age.secrets = {
    github-runner-ams1 = {
      file = ../../../secrets/github-runner-ams1.age;
      owner = "github-runner";
      group = "github-runner";
    };
    github-runner-nixos-config = {
      file = ../../../secrets/github-runner-nixos-config.age;
      owner = "github-runner";
      group = "github-runner";
    };
  };
  services = {
    github-runners = {
      "nixos-config" = {
        enable = true;
        url = "https://github.com/pilz0/nixos-config";
        name = "ams1-runner";
        replace = true;
        tokenFile = config.age.secrets.github-runner-nixos-config.path;
      };
      "ams1" = {
        enable = true;
        url = "https://github.com/as214958";
        name = "ams1-runner";
        replace = true;
        tokenFile = config.age.secrets.github-runner-ams1.path;
      };
    };
  };
}
