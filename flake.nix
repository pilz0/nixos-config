{
  description = "PilzOS";
  inputs = {
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-25.05";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
    agenix = {
      url = "github:ryantm/agenix";
    };
    #    catppuccin.url = "github:catppuccin/nix";
    nixarr = {
      url = "github:rasmus-kirk/nixarr";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    colmena = {
      url = "github:zhaofengli/colmena";
      inputs.nixpkgs.follows = "nixpkgs";

    };
  };
  outputs =
    {
      self,
      nixpkgs,
      agenix,
      #      catppuccin,
      #      lix-module,
      nixos-hardware,
      nixarr,
      home-manager,
      spicetify-nix,
      disko,
      colmena,
      ...
    }@inputs:
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      colmenaHive = colmena.lib.makeHive {
        meta = {
          nixpkgs = import nixpkgs {
            system = "x86_64-linux";
            overlays = [ ];
          };
        };
        "dus1.as214958.net" = {
          deployment = {
            targetHost = "oob.dus1.as214958.net";
            targetPort = 22;
            targetUser = "root";
          };
          time.timeZone = "Europe/Berlin";
        };
      };
      nixosConfigurations = {
        serva = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit self;
            inherit inputs;
            inherit nixarr;
            inherit agenix;

          };
          system = "x86_64-linux";
          modules = [
            ./serva/serva.nix
            ./common.nix
            ./common-pkgs.nix
            agenix.nixosModules.default
            nixarr.nixosModules.default
            #            lix-module.nixosModules.default
            {
              environment.systemPackages = [ agenix.packages.x86_64-linux.default ];
            }
          ];
        };
        "dus1.as214958.net" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit self;
            inherit inputs;
            inherit agenix;
          };
          system = "x86_64-linux";
          modules = [
            ./dus1.as214958.net/main.nix
            ./common.nix
            agenix.nixosModules.default
            disko.nixosModules.disko

            {
              environment.systemPackages = [
                agenix.packages.x86_64-linux.default
              ];
            }
          ];
        };

        framwok = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit agenix;
            inherit spicetify-nix;
            #            inherit catppuccin;
          };
          system = "x86_64-linux";
          modules = [
            agenix.nixosModules.default
            ./framwok/framwok.nix
            ./common.nix
            ./common-pkgs.nix
            #            ./framwok/home.nix # home manager
            nixos-hardware.nixosModules.framework-12th-gen-intel
            #            catppuccin.nixosModules.catppuccin
            #            lix-module.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              environment.systemPackages = [
                agenix.packages.x86_64-linux.default
              ];
            }

          ];
        };
      };
    };
}
