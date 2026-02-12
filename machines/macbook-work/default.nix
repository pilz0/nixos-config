{
  pkgs,
  ...
}:
{
  imports = [
    ../../modules/darwin/pkgs
    ../../modules/darwin/rosetta-builder
  ];

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
