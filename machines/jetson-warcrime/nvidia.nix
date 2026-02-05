{
  services.nvpmodel = {
    enable = true;
    profileNumber = 0;
  };

  hardware = {
    nvidia-container-toolkit.enable = true;
    nvidia-jetpack = {
      enable = true;
      configureCuda = true;
      som = "xavier-agx";
      carrierBoard = "devkit";
      modesetting.enable = false;
    };
  };

  # use hdmi port
  # https://github.com/anduril/jetpack-nixos?tab=readme-ov-file#linux-console
  boot.kernelParams = [ "fbcon=map:2" ];
}
