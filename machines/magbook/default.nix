{
  pkgs,
  ...
}:
{
  imports = [
    ./nix-build.nix
    ../../modules/darwin/rosetta-builder
    ../../modules/darwin/pkgs
  ];

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

  nix-rosetta-builder = {
    cores = 10;
  };

  nixpkgs.system = "aarch64-darwin";
  system.stateVersion = 6;
  nixpkgs.config.allowUnfree = true;
}
