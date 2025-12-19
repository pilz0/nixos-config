{
  config,
  ...
}:
{
  age.secrets.rcloneconfig = {
    file = ../../secrets/rclone.age;
    owner = "marie";
  };
  age.secrets.restic = {
    file = ../../secrets/restic.age;
    owner = "marie";
  };
  services.restic.backups = {
    onedrive = {
      rcloneConfigFile = config.age.secrets.rcloneconfig.path;
      user = "marie";
      repository = "rclone:onedrive:/backup/server";
      initialize = true;
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
