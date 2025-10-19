{
  pkgs,
  inputs,
  # spicetify-nix,
  ...
}:
{

  imports = [
    inputs.home-manager.nixosModules.home-manager
    #    inputs.spicetify-nix.nixosModules.spicetify
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.marie = {
      stateVersion = "24.11";
      username = "marie";
      homeDirectory = "/home/marie";

      home.packages = with pkgs; [
        # ...
        (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
        # ...
      ];

      imports = [
        #       inputs.catppuccin.homeModules.catppuccin
        #       inputs.spicetify-nix.homeManagerModules.spicetify
        inputs.agenix.homeManagerModules.age
        #        ./spicetify.nix
      ];
    };
  };
}
