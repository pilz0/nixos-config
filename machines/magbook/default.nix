{
  ...
}:
{
  imports = [
    ./pkgs
  ];

  # enable on setup for rosetta builder
  # nix.linux-builder.enable = true;
  nix-rosetta-builder.onDemand = true;
  nixpkgs.system = "aarch64-darwin";
  system.stateVersion = 6;

 nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
      "cgroups"
      "pipe-operators"
    ];
  };
  nixpkgs.config.allowUnfree = true;
}