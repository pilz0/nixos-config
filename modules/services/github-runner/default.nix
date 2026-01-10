{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.srvos.nixosModules.roles-github-actions-runner
    inputs.srvos.nixosModules.server
  ];

  age.secrets.github-runner = {
    file = ../../../secrets/github-runner.age;
    owner = "github-runner";
    group = "github-runner";
  };

  users = {
    users.github-runner = {
      group = "github-runner";
      isSystemUser = true;
    };
    groups.github-runner = { };
  };

  services = {
    github-runners = {
      "nixos-config" = {
        user = "github-runner";
        enable = true;
        url = "https://github.com/pilz0/nixos-config";
        name = "ams1-runner";
        replace = true;
        tokenFile = config.age.secrets.github-runner.path;
      };
      "better-journal" = {
        extraPackages = with pkgs; [
          curl
          wget
          cacert
          #androidenv.androidPkgs.androidsdk
          jetbrains.jdk
        ];
        user = "github-runner";
        enable = true;
        url = "https://github.com/pilz0/better-journal";
        name = "ams1-runner";
        replace = true;
        tokenFile = config.age.secrets.github-runner.path;
      };
      "ams1" = {
        user = "github-runner";
        enable = true;
        url = "https://github.com/as214958";
        name = "ams1-runner";
        replace = true;
        tokenFile = config.age.secrets.github-runner.path;
      };
    };
  };
}
