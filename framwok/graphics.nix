# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  pkgs,
  ...
}:
{
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  #X11 Server
  services.xserver.enable = true;
  hardware.graphics.enable = true;
  services.xserver.xkb.variant = "";
  services.xserver.xkb.layout = "de";

  environment.systemPackages = with pkgs; [
    gnomeExtensions.burn-my-windows
    gnomeExtensions.desktop-cube
    gnomeExtensions.compiz-windows-effect
    gnomeExtensions.vitals
    gnomeExtensions.media-controls
  ];
}
