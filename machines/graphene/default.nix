# sudo nixos-rebuild switch --flake github:pilz0/nixos-config#graphene
{ ... }:
{
  imports = [
    ./avf.nix
    ./desktop.nix
    ./pkgs.nix
  ];

  pilz = {
    deployment = {
      targetHost = null;
      allowLocalDeployment = true;
      tags = [ "android" ];
    };
    common.enable = true;
    shell.enable = true;
  };

  avf.defaultUser = "droid";

  networking.hostName = "graphene";
  system.stateVersion = "25.11";
}
