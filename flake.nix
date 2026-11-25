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
      colmena,
      ...
    }@inputs:
    let
      sf = import ./lib/shinyflakes inputs;
    in
    {
      hydraJobs = {
        inherit (self) checks;
        inherit (self) packages;
        nixosConfigurations = sf.mapHydraHosts self.nixosConfigurations;
        tests = nixpkgs.legacyPackages.x86_64-linux.releaseTools.aggregate {
          name = "tests";
          constituents = builtins.attrValues (builtins.removeAttrs self.checks.x86_64-linux [ "formatting" ]);
        };
      };
      darwinConfigurations = sf.mapDarwinCfg {
        darwinHosts = sf.mapHostsMerge ./machines/darwin {
        };
      };
      colmenaHive = colmena.lib.makeHive (
        sf.mapColmenaMerge self.nixosConfigurations {
          meta = {
            nixpkgs = nixpkgs.legacyPackages.x86_64-linux;
            specialArgs = { inherit inputs; };
          };
        }
      );

      images =
        sf.mapImagesMerge self.nixosConfigurations
          [
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
            "jira"
          ]
          {
            jetson-warcrime-flash =
              self.nixosConfigurations.jetson-warcrime.config.system.build.initrdFlashScript;
          };

      nixosConfigurations = sf.mapNixosCfg {
        hosts = sf.mapHostsMerge ./machines {
          jetson-warcrime = {
            system = "aarch64-linux";
          };
          build-aarch64.system = "aarch64-linux";
          build-aarch64-2.system = "aarch64-linux";
          graphene.system = "aarch64-linux";
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
          jira-crack = pkgs.callPackage ./pkgs/jira-crack.nix { };
          jetson-stats = pkgs.callPackage ./pkgs/jetson-stats.nix { };
          netsage-sankey-panel = pkgs.callPackage ./pkgs/netsage-sankey-panel.nix {
            inherit (pkgs.grafanaPlugins) grafanaPlugin;
          };
        }
        // nixpkgs.lib.optionalAttrs (system == "aarch64-linux") {
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
    homebrew-apps = {
      url = "github:krishkrosh/homebrew-apps";
      flake = false;
    };
    anodyne-flake = {
      url = "github:AnodyneWiki/anodyne-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    anodyne-molpic = {
      url = "github:pilz0/anodyne-molpic/add-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    anodyne-api = {
      url = "github:pilz0/anodyne-api/add-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    anodyne-chrp = {
      url = "github:pilz0/anodyne-chrp/add-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox = {
      url = "git+https://woof.rip/pilz0/firefox.git?ref=fix-darwin-build";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ecc = {
      url = "github:affaan-m/ECC";
      flake = false;
    };
    vpnconfinement-jetson = {
      url = "git+ssh://git@github.com/pilz0/vpn-confinement-jetson.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    goonfin = {
      url = "github:pilz0/goonfin";
      flake = false;
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
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    colmena = {
      url = "github:nix-community/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    #    microvm.url = "github:microvm-nix/microvm.nix";
    emily-nixfiles = {
      url = "git+https://woof.rip/emily/nixfiles.git";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-needsreboot = {
      url = "git+https://codeberg.org/Mynacol/nixos-needsreboot.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jetpack = {
      url = "github:anduril/jetpack-nixos/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hydra-mcp = {
      url = "git+https://woof.rip/slopwife/hydra-mcp.git";
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
    spank = {
      url = "github:taigrr/spank";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    nixos-avf = {
      url = "github:nix-community/nixos-avf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wp4nix = {
      url = "git+https://git.helsinki.tools/helsinki-systems/wp4nix.git";
      flake = false;
    };
  };
}
