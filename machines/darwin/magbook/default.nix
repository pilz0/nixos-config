{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../../profiles/importAll
    ./nix-build.nix
    ../../../profiles/darwin
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

  nixpkgs.config.permittedInsecurePackages = [
    "lima-1.2.2"
    "lima-full-1.2.2"
    "lima-additional-guestagents-1.2.2"
    "electron-39.8.10"
  ];
  nix = {
    enable = false;
    settings.allowSubstitutes = true;
    settings.extra-trusted-users = [ "pilz" ];
    settings.experimental-features = [
      "nix-command"
      "flakes"
      "cgroups"
      "pipe-operators"
    ];
  };

  nixpkgs.system = "aarch64-darwin";
  system.stateVersion = 6;
  nixpkgs.config.allowUnfree = true;
}
