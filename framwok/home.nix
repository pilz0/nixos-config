{
  pkgs,
  inputs,
  # spicetify-nix,
  ...
}:
{

  imports = [
    inputs.home-manager.nixosModules.home-manager
    #    inputs.catppuccin.nixosModules.catppuccin
    #    inputs.spicetify-nix.nixosModules.spicetify
  ];
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {
      #      inherit spicetify-nix;
    };

home.packages = with pkgs; [
  # ...
  (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
  # ...
]
    users.marie = {
      home = {
        stateVersion = "24.11";
        username = "marie";
        homeDirectory = "/home/marie";
      };
      imports = [
        #        inputs.catppuccin.homeModules.catppuccin
        #       inputs.spicetify-nix.homeManagerModules.spicetify
        inputs.agenix.homeManagerModules.age
        #        ./spicetify.nix
      ];
      #      catppuccin = {
      #        enable = true;
      #        flavor = "mocha";
      #        accent = "mauve";
      #        gtk = {
      #          enable = true;
      #          size = "compact";
      #          tweaks = [ "rimless" ];
      #        };
      #      };

    };
  };
}
