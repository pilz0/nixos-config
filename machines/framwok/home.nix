{
  pkgs,
  inputs,
  # spicetify-nix,
  ...
}:
{

  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    imports = [
      inputs.agenix.homeManagerModules.age
    ];

    useGlobalPkgs = true;
    useUserPackages = true;

    users.marie = {
      stateVersion = "24.11";
      username = "marie";
      homeDirectory = "/home/marie";

      home.packages = with pkgs; [
        (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
      ];
    };
  };
}
