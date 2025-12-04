{
  config,
  ...
}:
{
  age.secrets."nixbuildssh" = {
    owner = "marie";
    group = "marie";
    file = ../../secrets/nixbuildssh.age;
  };

  programs.ssh.knownHosts = {
    "cache.as214958.net".publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHzi2rVKv/xy3+Q+In/T8SntPjTlxYR46Gqwf209iC9N root@build";
  };

  nix = {
    distributedBuilds = true;
    settings.trusted-public-keys = [
      "cache.as214958.net:YOUR_BUILDER_PUBLIC_KEY_HERE"
    ];
    buildMachines = [
      {
        hostName = "cache.as214958.net";
        protocol = "ssh-ng";
        sshUser = "root";
        sshKey = config.age.secrets.nixbuildssh.path;
        systems = [
          "i686-linux"
          "x86_64-linux"
        ];
        maxJobs = 10;
        speedFactor = 6;
        supportedFeatures = [
          "big-parallel"
          "kvm"
          "nixos-test"
        ];
      }
    ];
  };
}
