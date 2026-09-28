{
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.determinate.darwinModules.default
    ../../modules/darwin/colima
    ../../modules/darwin/pkgs
    ../../modules/substituters
    #    ../../modules/darwin/shell homemanager
  ];
  pilz = {
    substituters.enable = true;
    darwin.services.colima.enable = true;
    darwin.pkgs.enable = true;
  };

    determinateNix = {
    enable = true;
    customSettings = {
      extra-trusted-users = [ "pilz" ];
      use-case-hack = false;
      builders-use-substitutes = true;
      experimental-features = [
        "nix-command"
        "flakes"
        "cgroups"
        "pipe-operators"
      ];
    };
  };
  nixpkgs.system = "aarch64-darwin";
  system.stateVersion = 6;
  nixpkgs.config.allowUnfree = true;
}
