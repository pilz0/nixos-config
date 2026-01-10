# modified version of https://woof.rip/emily/nixfiles/src/branch/main/lib/shinyflakes/default.nix
{ nixpkgs, ... }:
let
  inherit (nixpkgs) lib;
in
lib.mapAttrs (system: platform: lib.systems.elaborate platform) {
  "x86_64-linux" = {
    system = "x86_64-linux";
  };

  "aarch64-linux" = {
    system = "aarch64-linux";
  };
}
