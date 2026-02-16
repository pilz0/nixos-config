{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../../modules/darwin/pkgs
    ../../modules/darwin/rosetta-builder
    inputs.home-manager.darwinModules.home-manager
  ];

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

  environment.systemPackages = [ inputs.agenix.packages.aarch64-darwin.default ];

  nixpkgs.system = "aarch64-darwin";
  system.stateVersion = 6;
  nixpkgs.config.allowUnfree = true;

  nix-rosetta-builder = {
    memory = "48GiB";
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
}
