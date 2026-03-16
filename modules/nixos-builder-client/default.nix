{
  config,
  lib,
  ...
}:
let
  cfg = config.pilz.services.nixosBuilderClient;
in
{
  options.pilz.services.nixosBuilderClient = {
    enable = lib.mkEnableOption "enable nixos builder client configuration";
    user = lib.mkOption {
      type = lib.types.str;
      default = "marie";
    };
    builderHost = lib.mkOption {
      type = lib.types.str;
      default = "cache.as214958.net";
    };
    sshUser = lib.mkOption {
      type = lib.types.str;
      default = "root";
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets."nixbuildssh" = {
      owner = cfg.user;
      group = "users";
      file = ../../secrets/nixbuildssh.age;
    };

    programs.ssh.knownHosts = {
      "cache.as214958.net".publicKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHzi2rVKv/xy3+Q+In/T8SntPjTlxYR46Gqwf209iC9N root@build";
    };

    nix = {
      distributedBuilds = true;
      #    settings.trusted-public-keys = [
      #      "cache.as214958.net:YOUR_BUILDER_PUBLIC_KEY_HERE"
      #    ];
      buildMachines = [
        {
          hostName = cfg.builderHost;
          protocol = "ssh-ng";
          sshUser = cfg.sshUser;
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
  };
}
