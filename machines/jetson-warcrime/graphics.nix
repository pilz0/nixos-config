{
  lib,
  ...
}:
{
  users.users.marie.extraGroups = [
    "video"
    "audio"
  ];

  hardware = {
    graphics.enable = true;
  };

  users.groups.debug = { };

  environment.sessionVariables = rec {
    EDITOR = "nano";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
  };

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
  hardware.graphics.enable32Bit = lib.mkForce false;

  programs.dconf.enable = true;
}
