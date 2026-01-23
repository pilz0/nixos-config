{
  pkgs,
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

  services.xserver.displayManager.defaultSession = "none+i3";
  users.groups.debug = {};
  services.xserver.videoDrivers = ["nvidia"];

  services.xserver.displayManager.lightdm.extraConfig = ''
    logind-check-graphical = false
  '';

  environment.sessionVariables = rec {
    EDITOR = "nano";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
  };

  services = {
    xserver = {
      enable = true;
      xkb.layout = "de";

      displayManager.lightdm = {
        enable = true;
        greeters.slick.enable = true;
      };

      displayManager.gdm.enable = false;

      windowManager.i3 = {
        enable = true;
      };
    };
  };
  hardware.graphics.enable32Bit = lib.mkForce false;

  programs.dconf.enable = true;
}
