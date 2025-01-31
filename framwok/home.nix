{
  inputs,
  spicetify-nix,
  ...
}:
{

  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.catppuccin.nixosModules.catppuccin
    inputs.spicetify-nix.nixosModules.default
  ];
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {
      inherit spicetify-nix;
    };

    users.marie = {
      home = {
        stateVersion = "24.11";
        username = "marie";
        homeDirectory = "/home/marie";
      };
      imports = [
        inputs.catppuccin.homeManagerModules.catppuccin
        inputs.spicetify-nix.homeManagerModules.default
        inputs.agenix.homeManagerModules.age
        ./spicetify.nix
      ];

      catppuccin = {
        gtk = {
          enable = true;
          size = "compact";
          tweaks = [ "rimless" ];
        };
        enable = true;
        flavor = "mocha";
        accent = "mauve";
      };

    };
  };
}
