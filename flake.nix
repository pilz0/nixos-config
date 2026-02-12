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
      nixos-needsreboot,
      flake-utils,
      jetpack,
      nix-darwin,
      nix-rosetta-builder,
      determinate,
      disko,
      home-manager,
      nixpkgs-unstable,
      agenix,
      ...
    }@inputs:
    let
      sf = import ./lib/shinyflakes inputs;
    in
    {
      darwinConfigurations = {
        "magbook" = nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit inputs;
            pkgs-unstable = import nixpkgs-unstable {
              system = "aarch64-darwin"; # Change to x86_64-darwin if on Intel
              config.allowUnfree = true;
            };
          };
          modules = [
            ./machines/magbook
            home-manager.darwinModules.home-manager
            agenix.nixosModules.default
            {
              environment.systemPackages = [ agenix.packages.aarch64-darwin.default ];
            }
            {
              users.users.pilz.home = /Users/pilz;
              home-manager = {
                backupFileExtension = "bck";
                useGlobalPkgs = true;
                useUserPackages = true;
                users.pilz = ./machines/magbook/home.nix;
              };
            }
          ];
        };
        "macbook-work" = nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit inputs;
            pkgs-unstable = import nixpkgs-unstable {
              system = "aarch64-darwin"; # Change to x86_64-darwin if on Intel
              config.allowUnfree = true;
            };
          };
          modules = [
            ./machines/macbook-work
            home-manager.darwinModules.home-manager
            agenix.nixosModules.default
            {
              environment.systemPackages = [ agenix.packages.aarch64-darwin.default ];
            }
            {
              users.users.pilz.home = /Users/pilz;
              home-manager = {
                backupFileExtension = "bck";
                useGlobalPkgs = true;
                useUserPackages = true;
                users.pilz = ./machines/macbook-work/home.nix;
              };
            }
          ];
        };
      };
      colmena = sf.mapColmenaMerge self.nixosConfigurations {
        meta = {
          nixpkgs = nixpkgs.legacyPackages.x86_64-linux;
          specialArgs = { inherit inputs; };
        };
      };
      nixosConfigurations = sf.mapNixosCfg {
        hosts = sf.mapHostsMerge ./machines {
          jetson-warcrime.system = "aarch64-linux";
          build-aarch64.system = "aarch64-linux";
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
          packages = with pkgs; [
            colmena
            agenix-cli
          ];
        };
      }
    );

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    agenix.url = "github:ryantm/agenix";
    nixarr.url = "github:rasmus-kirk/nixarr";
    catppuccin.url = "github:catppuccin/nix";
    harmonia.url = "github:nix-community/harmonia";
    colmena.url = "github:zhaofengli/colmena";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-needsreboot = {
      url = "github:thefossguy/nixos-needsreboot";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jetpack = {
      url = "github:anduril/jetpack-nixos/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-rosetta-builder = {
      url = "github:pilz0/nix-rosetta-builder";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
