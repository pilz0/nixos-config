{ config, ... }:
{
  age.secrets.rcloneconfig = {
    file = ../secrets/rclone.age;
    owner = "marie";
    group = "marie";
  };
  age.secrets.restic = {
    file = ../secrets/restic.age;
    owner = "marie";
    group = "marie";
  };
  services.restic.backups = {
    onedrive = {
      rcloneConfigFile = config.age.secrets.rcloneconfig.path;
      user = "marie";
      repository = "rclone:onedrive:/backup/server";
      initialize = true; # initializes the repo, don't set if you want manual control
      passwordFile = config.age.secrets.restic.path;
      paths = [
        "/home/marie"
      ];
      exclude = [
        "*/.cache/*"
        "*/.local/share/Trash/*"
        "*/.steam/*"
      ];
    };
  };
}
