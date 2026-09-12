{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.mira.services.vaultwarden;
in
{
  imports = [
    inputs.sops-nix.nixosModules.sops
    inputs.emily-nixfiles.nixosModules.restic
    inputs.emily-nixfiles.nixosModules.nginx
  ];

  options.mira.services.vaultwarden =
    let
      inherit (lib) mkOption types;
    in
    {
      enable = lib.mkEnableOption "Enable miras vaultwarden";
      domain = mkOption {
        description = "domain";
        type = types.nonEmptyStr;
        default = "vault.kyouma.net";
      };
      snmpHost = mkOption {
        type = types.nonEmptyStr;
        default = "mail.kyouma.net";
      };
      snmpFrom = mkOption {
        type = types.nonEmptyStr;
        default = "vault@kyouma.net";
      };

    };

  config = lib.mkIf cfg.enable {
    sops.secrets."services/vaultwarden/environmentFile" = {
      sopsFile = "${inputs.emily-nixfiles}/secrets/services/vaultwarden.yaml";
      owner = "vaultwarden";
    };
    sops.secrets."services/vaultwarden/basicAuth" = {
      sopsFile = "${inputs.emily-nixfiles}/secrets/services/vaultwarden.yaml";
      owner = "nginx";
    };
    services.vaultwarden = {
      enable = true;
      environmentFile = config.sops.secrets."services/vaultwarden/environmentFile".path;
      backupDir = "/var/backup/bitwarden_rs";
      config = {
        DOMAIN = "https://${cfg.domain}";
        DATABASE_MAX_CONNS = 15;
        WEB_VAULT_ENABLED = true;
        WEBSOCKET_ADDRESS = "::1";
        SENDS_ALLOWED = true;
        ORG_ATTACHMENT_LIMIT = 1048576;
        USER_ATTACHMENT_LIMIT = 524288;
        USER_SEND_LIMIT = 1048576;
        INCOMPLETE_2FA_TIME_LIMIT = 5;
        SIGNUPS_ALLOWED = true;
        SIGNUPS_VERIFY = true;
        INVITATION_ORG_NAME = cfg.domain;
        PASSWORD_ITERATIONS = 1200000;
        ICON_DOWNLOAD_TIMEOUT = 30;
        SMTP_HOST = cfg.snmpHost;
        SMTP_FROM = cfg.snmpFrom;
        SMTP_FROM_NAME = cfg.domain;
        SMTP_USERNAME = cfg.snmpFrom;
        SMTP_SECURITY = "starttls";
        SMTP_PORT = 587;
        ROCKET_ADDRESS = "::1";
        ROCKET_PORT = 8222;
      };
    };
    kyouma.nginx.virtualHosts.${cfg.domain} = {
      locations."/" = {
        proxyPass = "http://[::1]:8222";
        proxyWebsockets = true;
      };
      locations."/admin" = {
        proxyPass = "http://[::1]:8222";
        basicAuthFile = config.sops.secrets."services/vaultwarden/basicAuth".path;
      };
    };
    security.acme.certs.${cfg.domain} = { };

    kyouma.restic.paths = [
      config.services.vaultwarden.backupDir
    ];
  };
}
