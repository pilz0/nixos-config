{
  pkgs,
  ...
}:
{
  imports = [
    ../../modules/container
    ../../modules/container/network.nix
    ../../modules/services/github-runner
    ../../modules/services/nixos-builder
    ../../modules/services/binary-cache
    ../../modules/services/forgejo-runner
  ];

  pilz = {
    deployment.targetHost = "build.ams1.as214958.net";
    lxc.enable = true;
    lxc.ctID = "106";
  };

  # if a build uses a lot of tmp storage ram will overflow
  boot.tmp.useTmpfs = false;

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    containerlab
    tmux
    screen
  ];

  nix.settings.extra-sandbox-paths = [ "/var/cache/ccache" ];
  users.users = {
    root = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMV2aYEGk2+r506hk7+ogDwNWa1cuAJt/4o7nwBiYtnC"
      ];
    };
    rhea = {
      extraGroups = [
        "wheel"
      ];
      isNormalUser = true;
      initialPassword = "foobar1312";
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5EyuXr+Uet0qxmQMOECuFSTHPBU7w3F9HglKN5DeZ6GU93dn2KCD9oD3ZWk4pSR7hzWiBYy0Mdcv1Bu3OQLDGBlYSPp7xUHd6XvZpR/grf4L3cUtuKBzIaUQi5Ehv3drJKhfkJUZoiJZbApNneLpn7Avy4xr/wa7azabqXsFeKimblBrhWookyPmT3E1VU8L0vad0yt0y44+tlVK6AoRlEqIRJbzhlCu1ws/lFIWswHbrbhIAiMRbEK+Wr7muERd0UZ96madAyvtixwbPx+qnpxnQjo0vw6Le4pT8ouF8jivcFJbeGGS0ZqdatOiawq/MP4oNqofCuF9Lk1jSL4N9OVaQ9mS6emqq3KKAZsxUSh7UTdTrZI50GRbgM0xLJr4zDa1Ic//jLGisXc/sE5k/LWHCwYc2QojHqRvkiJmPfquWjX7M9FVu2u4VUI9Ki1O7C5rCkn0jr8HStth7WqgjgAvUFUpmNKTl1LKDt/vuL9Xj+FMDocirbPvAM4qpgGGo5yuM9Dk9NKzIIjDHKO1cy86ZIS3W7YJaw1XjS6sKc9htDs+MMBJ9QZLvOCK4GG0dfl0SvQiOpEE8uwQau6NrUuhmB84P1hGiIGiM1Mfgjd4gQ4SqSB3n2OTILuYjZMzWXvbgWqe+plyeZB0NVu1afr6LoGxRjCXV3iC2WQvh3Q=="
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICz3LrNuJ1sS6w0ksY6lztpk/aegcLk9xyszDB6Q9sz7"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII1mECV9Etr/nLIgg1E2mpFvAW1RexhhsRKrF7XcDEZI marie@framwok"
      ];
    };
    ellie = {
      extraGroups = [
        "wheel"
      ];
      isNormalUser = true;
      initialPassword = "foobar1312";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHDUfJiyMvMIo9hL482dkPq4DUy+tQZ69DyBSQNclvpc ellie@macbook"
      ];
    };
  };

  nix.settings = {
    max-jobs = 10;
    cores = 36;
  };

  networking = {
    hostName = "build";
    hostId = "12163e34";
  };

  systemd.network.networks."10-eth0".address = [
    "10.10.10.8/24"
    "2a0e:8f02:f017::8/48"
  ];

  networking.firewall = {
    allowedTCPPorts = [
      80
      443
    ];
    allowedUDPPorts = [
    ];
  };
}
