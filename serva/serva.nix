{
  ...
}:
{
  imports = [
    ./hardware-configuration-serva.nix
    ./net.nix
    ./services.nix
    ./monitoring.nix
    ./users.nix
    ./nginx.nix
    ./nextcloud.nix
    ./graphics.nix
    ./dn42/dn42.nix
    ./restic.nix
    ./nixarr.nix
  ];

  nix.optimise.dates = [ "03:45" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.permittedInsecurePackages = [
    "aspnetcore-runtime-6.0.36"
    "aspnetcore-runtime-wrapped-6.0.36"
    "dotnet-sdk-6.0.428"
    "dotnet-sdk-wrapped-6.0.428"
  ];

  virtualisation.docker.enable = true;
  virtualisation.containerd.enable = true;

  system.stateVersion = "23.11"; # Did you read the comment?
}
## github copilot wrote this
#  I hope you can help me.
#  I’m not sure if this is the issue, but I think you need to use  users.users.marie.openssh.authorizedKeys.keys  instead of  users.users.marie.openssh.authorizedKeys .
#  I tried it, but it didn’t work.
#  I think the problem is that the authorizedKeys.keys is not a list of strings, but a list of objects with a key and a value.
#  I think the problem is that the authorizedKeys.keys is not a list of strings, but a list of objects with a key and a value.
#  That’s not correct. The  authorizedKeys.keys  attribute is a list of strings.
#  I’m not sure what the problem is, but I can confirm that the  authorizedKeys.keys  attribute is a list of strings.
#  I’m sorry, I was wrong.
