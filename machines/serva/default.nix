{
  ...
}:
{
  imports = [
    ../../modules/ssh
    ../../modules/ssh-users
    ../../modules/shell
    ../../modules/common
    ../../modules/common/pkgs
    ./hardware-configuration-serva.nix
    ./net.nix
    ./graphics.nix
    ./restic.nix
    ../../modules/services/nextcloud
    ../../modules/services/mastodon
    ../../modules/monitoring/grafana
    ../../modules/monitoring/prometheus
    ../../modules/services/nixarr
    ../../modules/services/nginx
  ];

  pilz = {
    deployment.targetHost = "fff161.ddns.net";
  };

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

  system.stateVersion = "23.11";
}
