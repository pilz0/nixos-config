{
  lib,
  pkgs,
  ...
}:
let
  # weston's panel only loads PNG; a missing icon falls back to a default one
  hicolor = pkg: name: "${pkg}/share/icons/hicolor/48x48/apps/${name}.png";
  westonIcon = name: "${pkgs.weston}/share/weston/icon_${name}.png";

  launchers = [
    {
      path = lib.getExe pkgs.alacritty;
      icon = westonIcon "terminal";
    }
    {
      path = lib.getExe pkgs.firefox;
      icon = hicolor pkgs.firefox "firefox";
    }
    {
      path = lib.getExe pkgs.thunderbird;
      icon = hicolor pkgs.thunderbird "thunderbird";
    }
    {
      path = lib.getExe' pkgs.libreoffice "soffice";
      icon = westonIcon "editor";
    }
    {
      path = lib.getExe pkgs.signal-desktop;
      icon = hicolor pkgs.signal-desktop "signal-desktop";
    }
    {
      path = lib.getExe pkgs.telegram-desktop;
      icon = hicolor pkgs.telegram-desktop "org.telegram.desktop";
    }
    {
      path = lib.getExe pkgs.gimp;
      icon = hicolor pkgs.gimp "gimp";
    }
  ];

  westonIni = pkgs.writeText "weston.ini" (
    lib.generators.toINI { } {
      core = {
        idle-time = 0; # the phone handles screen-off itself
      };
      shell = {
        locking = false;
        panel-position = "bottom";
        clock-format = "minutes";
        background-color = "0xff1e1e2e";
      };
    }
    + lib.concatMapStrings (l: "\n" + lib.generators.toINI { } { launcher = l; }) launchers
  );
in
{
  systemd.user.services.weston.serviceConfig.ExecStart = lib.mkForce (
    lib.concatStringsSep " " [
      (lib.getExe' pkgs.weston "weston")
      "--config=${westonIni}"
      "--backend=drm"
      "--modules=systemd-notify.so"
      "--xwayland"
      "--shell=desktop-shell.so"
      "--continue-without-input"
    ]
  );

  fonts.enableDefaultPackages = true;
}
