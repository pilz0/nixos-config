{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.nix-rosetta-builder.darwinModules.default
  ];

  programs.ssh.extraConfig = ''
    Host eu.nixbuild.net
    PubkeyAcceptedKeyTypes ssh-ed25519
    ServerAliveInterval 60
    IPQoS throughput
    IdentityFile /Users/pilz/.ssh/id_ed25519

    Host build-aarch64.as214958.net
    IdentityFile /Users/pilz/.ssh/id_ed25519
    ServerAliveInterval 60
    IPQoS throughput
  '';

  programs.ssh.knownHosts = {
    nixbuild = {
      hostNames = [ "eu.nixbuild.net" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIQCZc54poJ8vqawd8TraNryQeJnvH1eLpIDgbiqymM";
    };
  };

  # enable on setup for rosetta builder
  # nix.linux-builder.enable = true;
  nix-rosetta-builder = {
    onDemand = true;
    onDemandLingerMinutes = 60;
    cores = 10;
    jobs = 8;
    memory = "16GiB";
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

  nix = {
    distributedBuilds = true;
    buildMachines = [
      {
        sshUser = "root";
        hostName = "build-aarch64.as214958.net";
        system = "aarch64-linux";
        maxJobs = 4;
        speedFactor = 2;
        supportedFeatures = [
          "benchmark"
          "big-parallel"
        ];
      }
      {
        hostName = "eu.nixbuild.net";
        system = "aarch64-linux";
        maxJobs = 4;
        speedFactor = 1;
        supportedFeatures = [
          "benchmark"
          "big-parallel"
        ];
      }
    ];
  };
}
