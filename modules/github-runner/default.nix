{
  config,
  ...
}:
{
  virtualisation.docker.enable = true;
  age.secrets.github-runner-ams1 = {
    file = ../../secrets/github-runner-ams1.age;
    owner = "github-runner";
    group = "github-runner";
  };
  services = {
    github-runners = {
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
