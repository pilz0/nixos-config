{
  config,
  lib,
  ...
}:
{
  options.pilz.services.restic-client.enable = lib.mkEnableOption "";
  config = lib.mkIf config.pilz.services.restic-client.enable {
  age.secrets.rcloneconfig = {
    file = ../../secrets/rclone.age;
    owner = "root";
    group = "users";
  };
  age.secrets.restic = {
    file = ../../secrets/restic.age;
    owner = "root";
    group = "users";
  };
  services.restic.backups = {
    onedrive = {
      rcloneConfigFile = config.age.secrets.rcloneconfig.path;
      user = "root";
      repository = "rclone:onedrive:/backup/server";
      initialize = true;
      passwordFile = config.age.secrets.restic.path;
    };
  };
  };
}
