{
  pkgs,
  ...
}:
{
  imports = [
    ../../custom_pkgs/routinator_module.nix
  ];
  custom.routinator = {
    enable = true;
    package = pkgs.callPackage ../../custom_pkgs/routinator.nix { }; # routinator is out of date upstream
    settings = {
      enable-aspa = true;
      rtr-listen = [ "10.10.10.5:3323" ];
    };
  };
}
