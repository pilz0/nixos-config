{
  pkgs,
  ...
}:
{
  imports = [
    ./pkgs
    ./nix-build.nix
  ];

  # programs = {
  #  zsh = {
  #    enable = true;
  #  };
  #};

  # enable on setup for rosetta builder
  # nix.linux-builder.enable = true;
  nix-rosetta-builder = {
    onDemand = true;
    onDemandLingerMinutes = 60;
    cores = 10;
    jobs = 8;
    #  speedFactor = 4;
    memory = "16GiB";
  };

  nixpkgs.system = "aarch64-darwin";

  system.stateVersion = 6;

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
  nixpkgs.config.allowUnfree = true;
}
