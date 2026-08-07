{
  nix = {
    # nrBuildUsers = 16;
    gc.automatic = true;
    settings = {
      builders-use-substitutes = true;
      trusted-users = [
        "@trusted"
      ];
      # connect-timeout = 15;
      # max-silent-time = 2 * 3600;
      # timeout = 12 * 3600;
      narinfo-cache-positive-ttl = 3600;
      auto-optimise-store = true;
      trusted-public-keys = [
        "nix-community.cachix.org:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      substituters = [
        "https://nix-community.cachix.org"
      ];
      use-cgroups = true;
    };
  };
}
