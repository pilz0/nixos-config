{
  ...
}:
{

  imports = [
  ];
  nixpkgs = {
    overlays = [
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = true;
    };
  };

  home = {
    username = "marie";
    homeDirectory = "/home/marie";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
