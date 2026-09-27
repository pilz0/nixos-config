{
  description = "Pilz's nixos infra";
  nixConfig = {
    experimental-features = [
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
    hydraJobs = {
      inherit (self);
      nixosConfigurations = sf.mapHydraHosts self.nixosConfigurations;
    };
      darwinConfigurations = sf.mapDarwinCfg {
        darwinHosts = sf.mapHostsMerge ./machines/darwin {
        };
      };
      colmena = sf.mapColmenaMerge self.nixosConfigurations {
        meta = {
          nixpkgs = nixpkgs.legacyPackages.x86_64-linux;
          nodeNixpkgs = {
            jetson-warcrime = import inputs.nixpkgs {
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
        formatter = pkgs.nixfmt-tree;
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            colmena
            agenix-cli
          ];
        };
      }
    )
    // flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ] (system: {
      checks = sf.mapTests (sf.importPkgs system);
    });

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-2511.url = "github:nixos/nixpkgs/nixos-25.11";
    #fedi-bot.url = "git+ssh://git@github.com/pilz0/fedi-bot.git";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    agenix.url = "github:ryantm/agenix";
    nixarr-jetson = {
      url = "github:nix-media-server/nixarr";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.vpnconfinement.url = "git+ssh://git@github.com/pilz0/vpn-confinement-jetson.git";
    };
    nixarr.url = "github:nix-media-server/nixarr";

    catppuccin.url = "github:catppuccin/nix";
    colmena.url = "github:zhaofengli/colmena";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    #    microvm.url = "github:microvm-nix/microvm.nix";
    emily-nixfiles.url = "git+https://woof.rip/emily/nixfiles.git";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-needsreboot.url = "https://codeberg.org/Mynacol/nixos-needsreboot/archive/HEAD.tar.gz";
    jetpack = {
      url = "github:anduril/jetpack-nixos/master";
      inputs.nixpkgs.follows = "nixpkgs";
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
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wp4nix = {
      url = "git+https://git.helsinki.tools/helsinki-systems/wp4nix.git";
      flake = false;
    };
  };
}
