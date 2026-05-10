{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
    ../../../profiles/darwin
    ./nix-build.nix
  ];

  #pilz.services.darwin.colima.enable = true;
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

  nixpkgs.config.permittedInsecurePackages = [
  "lima-1.2.2"
    "lima-full-1.2.2"
    "lima-additional-guestagents-1.2.2"
  ];
  
  environment.systemPackages = [ inputs.agenix.packages.aarch64-darwin.default ];

  nixpkgs.system = "aarch64-darwin";
  system.stateVersion = 6;
  nixpkgs.config.allowUnfree = true;

  pilz.services.darwin.rosetta-builder = {
    memory = 48;
  };

  nix = {
    settings.extra-trusted-users = [ "pilz" ];
    settings.experimental-features = [
      "nix-command"
      "flakes"
      "cgroups"
      "pipe-operators"
      ];
  };
}
