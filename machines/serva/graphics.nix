{ pkgs, config, ... }:
{
  boot.initrd.kernelModules = [ "nvidia" ];
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libva-vdpau-driver
      intel-compute-runtime
    ];
  };
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    nvidiaSettings = true;
    powerManagement.finegrained = false;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };
}
