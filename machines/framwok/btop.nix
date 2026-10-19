{
  inputs,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.marie = {
      home.stateVersion = "23.11";
      programs.btop = {
        enable = true;
        settings = {
          theme_background = true;
          update_ms = 725;
          graph_symbol = "block";
        };
      };
    };
  };
}
