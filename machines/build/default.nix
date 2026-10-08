{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ../../profiles/vm
    ../../profiles/builder
  ];

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 32 * 1024; # 32 GiB
    }
  ];

  users.users = {
    emily = {
      extraGroups = [
        "wheel"
      ];
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA/+iN407+HsfHbbC3tfdA8Yf4TZ08qXQMb4tb/SDAs+"
      ];
    };
  };

  pilz = {
    services.pve-container.network = {
      enable = true;
      address = [
        "10.10.10.8/24"
        "2a0e:8f02:f017::8/64"
      ];
    };
    deployment = {
      targetHost = "build.ams1.as214958.net";
      tags = [
        "infra"
        "builder"
      ];
    };
  };

  nix.settings = {
    system-features = [
      "nixos-test"
      "benchmark"
      "big-parallel"
      "kvm"
    ];
    max-jobs = 10;
    cores = 36;
  };

  system.stateVersion = "23.11";

  networking = {
    hostName = "build";
    hostId = "12163e34";
  };

  networking.firewall = {
    allowedTCPPorts = [
      80
      443
    ];
    allowedUDPPorts = [
    ];
  };
}
