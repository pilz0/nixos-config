{
  ...
}:
{
  imports = [
    ./pkgs
  ];

  # enable on setup for rosetta builder
  # nix.linux-builder.enable = true;
  #nix-rosetta-builder = {
  #  onDemand = true;
  #  onDemandLingerMinutes = 60;
  #  cores = 10;
  #  jobs = 3;
  #  memory = "16GiB";
  #};

  nix.linux-builder = {
    enable = true;
    ephemeral = true;
    maxJobs = 4;
    config = {
      users.users.builder.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMQ7jmjCtBYBP7DcCJS1OmAgE9nfgUEezHnKmGwYsTmJ builder@localhost" ];
      virtualisation = {
        darwin-builder = {
          diskSize = 40 * 1024;
          memorySize = 8 * 1024;
        };
        cores = 6;
      };
    };
  };
  
  nixpkgs.system = "aarch64-darwin";

  system.stateVersion = 6;

  nix = {
    settings.extra-trusted-users = [ "pilz" ];
    settings.experimental-features = [
      "nix-command"
      "flakes"
      "cgroups"
      "pipe-operators"
    ];
  };
  nixpkgs.config.allowUnfree = true;
}