{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ../../profiles/vm
  ];

  users.users = {
    root = {
      openssh.authorizedKeys.keys = lib.mkAfter [
        "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBBVU8tZzImqrN/emvMzRyrz/hCQnZ9FHd/wt4+pUDQ74odQDjC9frGIZRZQ0HtSEVIv7ZJ/5tssPNZWxELZfKIgAAAAEc3NoOg== leafloofball.dev"
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIMBivQni5ffruN80zAVliVJ8X7CVIq8br+97Z6V9FNEGAAAADHNzaDpwZXJzb25hbA== ssh:personal"
      ];
    };
  };

  pilz = {
    services.pve-container.network = {
      enable = true;
      address = [
        "10.10.10.13/24"
        "2a0e:8f02:f017::23/64"
      ];
    };
    deployment = {
      targetHost = "lea.ams1.as214958.net";
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
    hostName = "lea";
    hostId = "1216de34";
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
