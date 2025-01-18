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
    #    (catppuccin-gtk.override {
    #      accents = [ "pink" ]; # You can specify multiple accents here to output multiple themes
    #      tweaks = [ "rimless" ]; # You can also specify multiple tweaks here
    #      variant = "mocha";
    #    })
    gnomeExtensions.burn-my-windows
    gnomeExtensions.desktop-cube
    gnomeExtensions.compiz-windows-effect
  ];
}
