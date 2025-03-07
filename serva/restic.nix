{ config, ... }:
{
  age.secrets.rcloneconfig = {
    file = ../secrets/rclone.age;
    owner = "root";
    group = "root";
  };
  services.restic.backups = {
    onedrive = {
      rcloneConfigFile = config.age.secrets.rcloneconfig.path;
      user = "root";
      repository = "rclone:onedrive:/Buro/backup";
      initialize = true; # initializes the repo, don't set if you want manual control
      passwordFile = config.age.secrets.restic.path;
      paths = [
        "/home/marie"
        "/var/"
      ];
      timerConfig = {
        onCalendar = "sunday 11:00";
      };
    };
  };
}
