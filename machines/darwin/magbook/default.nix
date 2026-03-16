{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./nix-build.nix
    ../../../modules/darwin
  ];

  environment.systemPackages = [ inputs.agenix.packages.aarch64-darwin.default ];
  users.users.pilz.home = /Users/pilz;
  home-manager = {
    backupFileExtension = "bck";
    useGlobalPkgs = true;
    useUserPackages = true;
    users.pilz = {
      imports = [
        inputs.agenix.homeManagerModules.default
        ./home.nix
      ];
    };
  };

  nix = {
    package = pkgs.lix;
    settings.extra-trusted-users = [ "pilz" ];
    settings.experimental-features = [
      "nix-command"
      "flakes"
      "cgroups"
      "pipe-operator"
    ];
  };

  pilz.services.darwin.rosetta-builder = {
    cores = 10;
    jobs = 10;
  };

  nixpkgs.system = "aarch64-darwin";
  system.stateVersion = 6;
  nixpkgs.config.allowUnfree = true;
}
