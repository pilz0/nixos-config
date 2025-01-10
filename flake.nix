{
  description = "PilzOS";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    agenix.url = "github:ryantm/agenix";
    nixarr.url = "github:rasmus-kirk/nixarr";
    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      agenix,
      nixarr,
      home-manager,
      spicetify-nix,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      pkgs = import nixpkgs { system = "x84_64-linux"; };
    in
    {
      homeConfigurations."marie" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./framwok/home.nix
          spicetify-nix.homeManagerModules.default
        ];
      };
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
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
            agenix.nixosModules.default
            nixarr.nixosModules.default
            {
              environment.systemPackages = [ agenix.packages.x86_64-linux.default ];
            }
          ];
        };
        framwok = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
            inherit spicetify-nix;
          };
          modules = [
            agenix.nixosModules.default
            ./framwok/framwok.nix
            ./common.nix
            spicetify-nix.nixosModules.default
            {
              environment.systemPackages = [ agenix.packages.x86_64-linux.default ];
            }
          ];
        };
      };
    };
}
