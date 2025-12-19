{
  pkgs,
  ...
}:
{
  services.xserver.enable = true;
  hardware.graphics.enable = true;
  services.xserver.xkb.variant = "";
  services.xserver.xkb.layout = "de";
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  environment.systemPackages = with pkgs; [
    catppuccin-gtk
    gnome-themes-extra
    gnomeExtensions.burn-my-windows
    gnomeExtensions.desktop-cube
    gnomeExtensions.compiz-windows-effect
    gnomeExtensions.vitals
    gnomeExtensions.media-controls
    gnomeExtensions.user-themes
  ];
}
