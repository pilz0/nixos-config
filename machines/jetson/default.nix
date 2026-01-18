{
  inputs,
  ...
}:
{
  imports = [
    inputs.jetpack.nixosModules.default
    ../../modules/ssh
    ../../modules/ssh-users
    ../../modules/shell
    ../../modules/common
    ../../modules/common/pkgs
    ./graphics.nix
    ./hardware-configuration.nix
  ];

  pilz = {
    deployment = {
      targetHost = "192.168.1.242";
      buildOnTarget = true;
    };
  };

networking.firewall.allowedTCPPorts = [ 22 ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware = {
    nvidia-container-toolkit.enable = true;
  virtualisation = {
    docker.enable = true;
    podman.enable = true;
  };

  nvidia-jetpack.enable = true;
  nvidia-jetpack.som = "xavier-agx";
  nvidia-jetpack.carrierBoard = "devkit";
};
}
