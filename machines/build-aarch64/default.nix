{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
    ../../modules/services/nixos-builder
    # ../../modules/services/binary-cache
    ../../modules/common
    ../../modules/ssh
    ../../modules/ssh-users
    ../../modules/shell
    ../../modules/monitoring/node-exporter
    ../../modules/common/pkgs
    ./hardware-configuration.nix
    ./disk-config.nix
  ];

  pilz = {
    deployment = {
      targetHost = "89.168.97.129";
      tags = [ "infra" ];
    };
  };

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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "net.ifnames=0" ];

  systemd.network.networks = {
    "10-eth0" = {
      networkConfig = {
        IPv6AcceptRA = true;
      };
      matchConfig.Name = "eth0";
      linkConfig.RequiredForOnline = "routable";
      address = [
        "10.0.0.45/24"
      ];
      routes = [
        {
          Gateway = "10.0.0.1";
          Destination = "0.0.0.0/0";
          GatewayOnLink = true;
        }
      ];
    };
  };
  networking.useDHCP = false;

  nix.settings = {
    max-jobs = 4;
    cores = 4;
  };

  networking = {
    useNetworkd = true;
    nameservers = lib.mkAfter [
      "2606:4700:4700::1111"
      "1.1.1.1"
      "2606:4700:4700::1001"
      "1.0.0.1"
    ];
  };

  networking = {
    hostName = "build-aarch64";
    hostId = "13243e34";
  };

  networking.firewall = {
    allowPing = true;
    allowedTCPPorts = [
      22
      80
      443
    ];
    allowedUDPPorts = [
    ];
  };
  system.stateVersion = "23.11";
}
