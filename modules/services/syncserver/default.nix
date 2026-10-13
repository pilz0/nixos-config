{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.pilz.services.syncserver;
in
{
  options.pilz.services.syncserver = {
    enable = lib.mkEnableOption "";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.nextcloud35;
    };
    domain = lib.mkOption {
      type = lib.types.str;
      default = "syncserver.as214958.net";
    };
    secretsFile = lib.mkOption {
      type = lib.types.path;
      default = config.age.secrets.syncserver-secrets.path;
    };
  };

  config = lib.mkIf config.pilz.services.nextcloud.enable {

    age.secrets.syncserver-secrets = {
      file = ../../../secrets/syncserver-secrets.age;
      mode = "640";
      owner = "firefox-syncserver";
      group = "firefox-syncserver";
    };

    services.firefox-syncserver = {
      inherit (cfg) enable;
      singleNode.enable = true;
      singleNode.enableTLS = true;
      singleNode.enableNginx = true;
      singleNode.hostname = cfg.domain;
      secrets = cfg.secretsFile;
    };
  };
}
