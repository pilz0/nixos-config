{
  description = "Pilz's nixos-based infra";
  nixConfig = {
    experimental-features = [
      "nix-command"
      "flakes"
      "pipe-operators"
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
      darwinConfigurations = sf.mapDarwinCfg {
        darwinHosts = sf.mapHostsMerge ./machines/darwin {
        };
      };
      colmena = sf.mapColmenaMerge self.nixosConfigurations {
        meta = {
          nixpkgs = nixpkgs.legacyPackages.x86_64-linux;
          nodeNixpkgs = {
            jetson-warcrime = import inputs.nixpkgs {
              #jetson-warcrime = import inputs.nixpkgs-2511 {
              system = "aarch64-linux";
              config.allowUnfree = true;
            };
          };
          specialArgs = { inherit inputs; };
        };
      };
      nixosConfigurations = sf.mapNixosCfg {
        hosts = sf.mapHostsMerge ./machines {
          jetson-warcrime = {
            system = "aarch64-linux";
            # jetpack-nixos only supports this channel (see inputs.nixpkgs-2511).
            #nixpkgs = inputs.nixpkgs-2511;
            nixpkgs = inputs.nixpkgs;
          };
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
        checks."grafana" = pkgs.callPackage ./tests/grafana.nix { };
        checks."as214958net" = pkgs.callPackage ./tests/as214958net.nix { };
        # packages = sf.eachSystem (system: sf.mapTestCfg pkgs);
        formatter = pkgs.nixfmt-tree;
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
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-2511.url = "github:nixos/nixpkgs/nixos-25.11";
    fedi-bot.url = "git+ssh://git@github.com/pilz0/fedi-bot.git";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    agenix.url = "github:ryantm/agenix";
    nixarr = {
      url = "github:nix-media-server/nixarr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    harmonia.url = "github:nix-community/harmonia";
    colmena.url = "github:zhaofengli/colmena";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    #    microvm.url = "github:microvm-nix/microvm.nix";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-needsreboot = {
      url = "github:thefossguy/nixos-needsreboot";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jetpack = {
      url = "path:/Users/pilz/Documents/jetpack-nixos";
      inputs.nixpkgs.follows = "nixpkgs-2511";
    };
    nix-darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-rosetta-builder = {
      url = "github:cpick/nix-rosetta-builder";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
