{
  pkgs,
  spicetify-nix,
  ...
}:
{
  programs.spicetify =
    let
      spicePkgs = spicetify-nix.legacyPackages.${pkgs.system};
    in
    {
      enable = true;
      enabledExtensions = with spicePkgs.extensions; [
        shuffle
        trashbin
        featureShuffle
        history
        oneko
        beautiful-lyrics
      ];
      theme = spicePkgs.themes.text;
    };
}
