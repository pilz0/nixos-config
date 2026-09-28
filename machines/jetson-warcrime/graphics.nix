{
  users.users.marie.extraGroups = [
    "video"
    "audio"
  ];

  environment.sessionVariables = rec {
    EDITOR = "nano";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
  };

  # use hdmi port
  # https://github.com/anduril/jetpack-nixos?tab=readme-ov-file#linux-console
  boot.kernelParams = [ "fbcon=map:2" ];

  services = {
    displayManager = {
      defaultSession = "none+i3";
    };
    xserver = {
      enable = true;
      xkb.layout = "de";
      videoDrivers = [ "nvidia" ];
      displayManager = {
        lightdm = {
          enable = true;
          greeters.slick.enable = true;
          extraConfig = ''
            logind-check-graphical = false
          '';
        };
      };
      windowManager.i3 = {
        enable = true;
      };
    };
  };
}
