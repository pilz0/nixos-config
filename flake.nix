{
  description = "Pilz's nixos-based infra";
  nixConfig = {
    experimental-features = [
      "nix-command"
      "flakes"
      "pipe-operator"
    ];
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }@inputs:
    let
      sf = import ./lib/shinyflakes inputs;
    in
    {
      colmena = sf.mapColmenaMerge self.nixosConfigurations {
        meta = {
          nixpkgs = nixpkgs.legacyPackages.x86_64-linux;
          specialArgs = { inherit inputs; };
        };
      };
      nixosConfigurations = sf.mapNixosCfg {
        hosts = sf.mapHostsMerge ./machines {
        };
      };
    }
    // flake-utils.lib.eachSystem flake-utils.lib.allSystems (
      system:
      let
        pkgs = sf.importPkgs system;
      in
      {
        formatter = nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.colmena
            pkgs.agenix-cli
          ];
        };
      }
    );

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    agenix.url = "github:ryantm/agenix";
    nixarr.url = "github:rasmus-kirk/nixarr";
    catppuccin.url = "github:catppuccin/nix";
    srvos.url = "github:nix-community/srvos";
    harmonia = {
      url = "github:nix-community/harmonia?ref=47d447dd3392dc97ea24d3368dfd84b14d2c5f09";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    colmena = {
      url = "github:poly2it/colmena?ref=51db9b8b829ab8ebc047121f18f80204f17c3233";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
