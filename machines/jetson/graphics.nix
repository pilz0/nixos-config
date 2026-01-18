{
  pkgs,
  ...
}:
{

  services = {
    xserver = {
      enable = true;
      xkb.layout = "de";
    };
    desktopManager.gnome.enable = true;
    displayManager = {
      gdm.enable = true;
      gdm.wayland = false;
    };
    gnome = {
      gnome-online-accounts.enable = false;
      core-developer-tools.enable = false;
      games.enable = false;
    };
  };

  hardware = {
    graphics.enable = true;
    nvidia-jetpack.modesetting.enable = true;
  };
  boot.kernelParams = [ "fbcon=map:2" ];

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
    gnome-maps
    gnome-logs
    gnome-usage
    gnome-music
    gnome-feeds
    gnome-weather
    gnome-secrets
    gnome-decoder
    geary
    epiphany
    papers
    decibels
    simple-scan
    showtime
    baobab
    seahorse
    gnome-system-monitor
  ];

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
