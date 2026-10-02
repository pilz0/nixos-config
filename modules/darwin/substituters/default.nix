{
  lib,
  config,
  ...
}:
let
  cfg = config.pilz.substituters;
in
{
  options.pilz.substituters = {
      enable = lib.mkEnableOption "";
  };
  config = lib.mkIf cfg.enable {

  determinateNix.customSettings = {
    extra-substituters = lib.mkAfter [
      "https://cache.kyouma.net"
      "https://nix-community.cachix.org"
      "https://cache.nixos-cuda.org"
      "https://cache.lix.systems"
      "https://nixpkgs-update-cache.nix-community.org"
      "https://install.determinate.systems"
    ];

    extra-trusted-public-keys = lib.mkAfter [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
      "cache.kyouma.net:Frjwu4q1rnwE/MnSTmX9yx86GNA/z3p/oElGvucLiZg="
      "nixpkgs-update-cache.nix-community.org-1:U8d6wiQecHUPJFSqHN9GSSmNkmdiFW7GW7WNAnHW0SM="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
    ];
  }; 
  };
}
