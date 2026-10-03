{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./nix-build.nix
    ../../../profiles/darwin
  ];

  services.tailscale = {
    enable = true;
  };
  environment.systemPackages = with pkgs; [
    tailscale
  ];

  users.users.pilz.home = /Users/pilz;
  home-manager = {
    backupFileExtension = "bck";
    useGlobalPkgs = true;
    useUserPackages = true;
    users.pilz = {
      imports = [
        inputs.agenix.homeManagerModules.default
        ./home.nix
      ];
    };
  };

  nixpkgs.config.permittedInsecurePackages = [
    "lima-1.2.2"
    "lima-full-1.2.2"
    "lima-additional-guestagents-1.2.2"
    "electron-39.8.10"
  ];
}
