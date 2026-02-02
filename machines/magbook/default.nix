{
  pkgs,
  ...
}:
{
  imports = [
    ./pkgs.nix
    ./nix-build.nix
  ];

  nixpkgs.system = "aarch64-darwin";
  system.stateVersion = 6;
  nixpkgs.config.allowUnfree = true;
}
