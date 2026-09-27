{
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.determinate.darwinModules.default
    ../../modules/darwin/colima
    ../../modules/darwin/pkgs
    #    ../../modules/darwin/shell homemanager
  ];
  pilz.darwin.services.colima.enable = true;
  pilz.darwin.pkgs.enable = true;

  nix.extraOptions = ''
    	  builders-use-substitutes = true
    '';
  nix.settings = {
    substituters = lib.mkAfter [
      "https://nix-community.cachix.org"
      "https://cache.lix.systems"
      "https://nixpkgs-update-cache.nix-community.org"
      "https://cache.kyouma.net"
      "ssh-ng://eu.nixbuild.net"
    ];

    trusted-public-keys = lib.mkAfter [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
      "nixpkgs-update-cache.nix-community.org-1:U8d6wiQecHUPJFSqHN9GSSmNkmdiFW7GW7WNAnHW0SM="
      "cache.kyouma.net:Frjwu4q1rnwE/MnSTmX9yx86GNA/z3p/oElGvucLiZg="
      "nixbuild.net/ESNM07-1:YgF6GxLE7YzWpfdw/Uz9Fq8gFgdj/9+BUnD40emGDYQ="
    ];
  };
}
