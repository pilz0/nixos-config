{
  pkgs,
  lib,
  ...
}:
{
  nix.settings = {
    trusted-users = lib.mkAfter [ "nix-ssh" ];

    substituters = lib.mkAfter [
      "https://nix-community.cachix.org"
      "https://cache.nixos-cuda.org"
      "https://cache.lix.systems"
      "https://nixpkgs-update-cache.nix-community.org"
      "https://cache.kyouma.net"
    ];

    trusted-public-keys = lib.mkAfter [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
      "cache.kyouma.net:Frjwu4q1rnwE/MnSTmX9yx86GNA/z3p/oElGvucLiZg="
      "nixpkgs-update-cache.nix-community.org-1:U8d6wiQecHUPJFSqHN9GSSmNkmdiFW7GW7WNAnHW0SM="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];
  };
  nix.extraOptions = ''
    	    min-free = ${toString (16384 * 1024 * 1024)}
    	    max-free = ${toString (32768 * 1024 * 1024)}
    	    max-substitution-jobs = 48
    	    http-connections = 64
    	    max-silent-time = 14400
  '';
  nix.sshServe = {
    enable = true;
    write = true;
    keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE/vCXM3IaxJP9v2Y+xcQrQD2IcffgdzqtWhpMjj9Xl5 hydra@seras"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII1mECV9Etr/nLIgg1E2mpFvAW1RexhhsRKrF7XcDEZI marie@framwok"
    ];
  };

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

  environment.systemPackages = with pkgs; [
    containerlab
    tmux
    screen
  ];
  boot.tmp.useTmpfs = false;
  virtualisation.docker.enable = true;
}
