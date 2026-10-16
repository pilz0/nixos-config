{
  description = "Pilz's nixos infra";
  nixConfig = {
    allow-import-from-derivation = true;
    extra-experimental-features = [
      "pipe-operators"
      "pipe-operator"
    ];
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      treefmt-nix,
      ...
    }@inputs:
    let
      sf = import ./lib/shinyflakes inputs;
    in
    {
      hydraJobs = {
        inherit (self) images;
        inherit (self) checks;
        inherit (self) packages;
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

      images = sf.mapImagesMerge self.nixosConfigurations [
        "tor1"
        "tor2"
        "tor3"
        "tor4"
        "tor5"
        "tor6"
        "tor7"
        "tor8"
        "build"
        "anodyne"
        "dn42"
        "jellyfin"
        "rpki"
        "grafana"
        "web1"
      ] { };

      nixosConfigurations = sf.mapNixosCfg {
        hosts = sf.mapHostsMerge ./machines {
          jetson-warcrime = {
            system = "aarch64-linux";
          };
          build-aarch64.system = "aarch64-linux";
          build-aarch64-2.system = "aarch64-linux";
        };
      };
    }
    // flake-utils.lib.eachSystem flake-utils.lib.allSystems (
      system:
      let
        pkgs = sf.importPkgs system;
        treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
      in
      {
        formatter = treefmtEval.config.build.wrapper;
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            colmena
            agenix-cli
          ];
        };
      }
    )
    // flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ] (
      system:
      let
        pkgs = sf.importPkgs system;
        treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
      in
      {
        packages = {
          flow-exporter = pkgs.callPackage ./pkgs/flow-exporter.nix { };
          jetson-stats = pkgs.callPackage ./pkgs/jetson-stats.nix { };
          netsage-sankey-panel = pkgs.callPackage ./pkgs/netsage-sankey-panel.nix {
            inherit (pkgs.grafanaPlugins) grafanaPlugin;
          };
        }
        // nixpkgs.lib.optionalAttrs (system == "aarch64-linux") {
          # needs the nvidia-jetpack overlay, so use the jetson host's pkgs
          jetson-ffmpeg =
            self.nixosConfigurations.jetson-warcrime.pkgs.callPackage ./pkgs/jetson-ffmpeg.nix
              { };
        };
      }
    )
    // flake-utils.lib.eachSystem [ "x86_64-linux" ] (
      system:
      let
        pkgs = sf.importPkgs system;
        treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
      in
      {
        checks = {
          formatting = treefmtEval.config.build.check self;
        }
        // sf.mapTests (sf.importPkgs system);

      }
    );

  inputs = {
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    anodyne-flake.url = "github:pilz0/anodyne-flake";
    anodyne-molpic.url = "github:pilz0/anodyne-molpic/add-nix-flake";
    anodyne-api.url = "github:pilz0/anodyne-api/add-nix-flake";
    anodyne-chrp.url = "github:pilz0/anodyne-chrp/add-nix-flake";
    firefox.url = "git+ssh://forgejo@woof.rip/pilz0/firefox.git?ref=fix-darwin-build";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #fedi-bot.url = "git+ssh://git@github.com/pilz0/fedi-bot.git";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    agenix.url = "github:ryantm/agenix";
    vpnconfinement-jetson = {
      url = "git+ssh://git@github.com/pilz0/vpn-confinement-jetson.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixarr-jetson = {
      url = "github:nix-media-server/nixarr";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.vpnconfinement.follows = "vpnconfinement-jetson";
    };
    nixarr = {
      url = "github:nix-media-server/nixarr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    colmena.url = "github:zhaofengli/colmena";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    #    microvm.url = "github:microvm-nix/microvm.nix";
    emily-nixfiles = {
      url = "git+https://woof.rip/emily/nixfiles.git";
      inputs.home-manager.follows = "home-manager";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-needsreboot.url = "https://codeberg.org/Mynacol/nixos-needsreboot/archive/HEAD.tar.gz";
    jetpack = {
      url = "github:anduril/jetpack-nixos/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
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
