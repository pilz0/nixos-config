{
  description = "PilzOS";
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-25.05";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
    agenix = {
      url = "github:ryantm/agenix";
    };
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
  };
  outputs =
    {
      self,
      nixpkgs,
      agenix,
      nixos-hardware,
      nixarr,
      home-manager,
      spicetify-nix,
      disko,
      ...
    }@inputs:
    {
      packages.x86_64-linux =
        let
          pkgs = import nixpkgs { system = "x86_64-linux"; };
        in
        {
          pmacct-custom = pkgs.callPackage ./custom_pkgs/pmacct.nix {
            withKafka = true;
            withJansson = true;
            withPgSQL = true;
            withSQLite = true;
          };
          flow-exporter-custom = pkgs.callPackage ./custom_pkgs/flow-exporter.nix { };
        };
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      nixosConfigurations = {
        "serva" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit self;
            inherit inputs;
            inherit nixarr;
            inherit agenix;

          };
          system = "x86_64-linux";
          modules = [
            ./serva
            agenix.nixosModules.default
            nixarr.nixosModules.default
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
            pmacct-custom = self.packages.x86_64-linux.pmacct-custom;
            flow-exporter-custom = self.packages.x86_64-linux.flow-exporter-custom;
          };
          system = "x86_64-linux";
          modules = [
            ./dus1.as214958.net
            agenix.nixosModules.default
            disko.nixosModules.disko
            {
              environment.systemPackages = [
                agenix.packages.x86_64-linux.default
                self.packages.x86_64-linux.flow-exporter-custom
                self.packages.x86_64-linux.pmacct-custom

              ];
            }
          ];
        };
        "framwok" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit agenix;
            inherit spicetify-nix;
          };
          system = "x86_64-linux";
          modules = [
            agenix.nixosModules.default
            ./framwok
            nixos-hardware.nixosModules.framework-12th-gen-intel
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
