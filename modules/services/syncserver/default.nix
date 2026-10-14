{
  lib,
  config,
  ...
}:
let
  cfg = config.pilz.services.syncserver;
in
{
  options.pilz.services.syncserver = {
    enable = lib.mkEnableOption "";
    domain = lib.mkOption {
      type = lib.types.str;
      default = "syncserver.as214958.net";
    };
    secretsFile = lib.mkOption {
      type = lib.types.path;
      default = config.age.secrets.syncserver-secrets.path;
    };
  };

  config = lib.mkIf cfg.enable {

    age.secrets.syncserver-secrets = {
      file = ../../../secrets/syncserver-secrets.age;
      mode = "640";
      owner = "firefox-syncserver";
      group = "firefox-syncserver";
    };

    services.firefox-syncserver = {
      enable = true;
      singleNode.enable = true;
      singleNode.enableTLS = true;
      singleNode.enableNginx = true;
      singleNode.hostname = cfg.domain;
      secrets = cfg.secretsFile;
      database.type = "mysql";
    };
  };
}
