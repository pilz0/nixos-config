{ config, inputs, lib, pkgs, ... }: let
  cfg = config.mira.services.forgejo;
in {
  options.mira.services.forgejo = {
    enable = lib.mkEnableOption "";
  };
  config = lib.mkIf cfg.enable {
    sops.secrets."services/forgejo/mailerPassword" = {
      sopsFile = "${inputs.emily-nixfiles}/secrets/services/forgejo.yaml";
      owner = "forgejo";
    };
    services.forgejo = {
      enable = true;
      package = pkgs.forgejo;
      secrets.mailer.PASSWD = config.sops.secrets."services/forgejo/mailerPassword".path;
      database = {
        createDatabase = true;
        type = "postgres";
        socket = "/run/postgresql";
      };
      dump = {
        enable = true;
        type = "tar.xz";
      };
      settings = {
        "cron.sync_external_users" = {
          RUN_AT_START = true;
          SCHEDULE = "@every 24h";
          UPDATE_EXISTING = true;
        };
        DEFAULT.APP_NAME = "The dog girl Git";
        federation.ENABLED = true;
        log.LEVEL = "Info";
        indexer = {
          REPO_INDEXER_ENABLED = true;
        };
        mailer = {
          ENABLED = true;
          PROTOCOL = "smtp+starttls";
          FROM = "git@kyouma.net";
          SMTP_ADDR = "mail.kyouma.net";
          USER = "git@kyouma.net";
        };
        mirror.DEFAULT_INTERVAL = "1h";
        oauth2_client.REGISTER_EMAIL_CONFIRM = false;
        openid = {
          ENABLE_OPENID_SIGNIN = true;
          ENABLE_OPENID_SIGNUP = true;
        };
        session = {
          COOKIE_SECURE = true;
          PROVIDER = "db";
          SESSION_LIFE_TIME = 2592000;
        };
        server = {
          STATIC_URL_PREFIX = "/static";
          PROTOCOL = "http+unix";
          DOMAIN = "woof.rip";
          ROOT_URL = "https://woof.rip";
        };
        security = {
          LOGIN_REMEMBER_DAYS = 90;
          PASSWORD_HASH_ALGO = "argon2";
          MIN_PASSWORD_LENGTH = 16;
          PASSWORD_COMPLEXITY = "spec";
        };
        service = {
          REGISTER_EMAIL_CONFIRM = true;
          ENABLE_NOTIFY_MAIL = true;
          ENABLE_CAPTCHA = true;
          DEFAULT_KEEP_EMAIL_PRIVATE = true;
        };
        repository.ENABLE_PUSH_CREATE_USER = true;
        ui = {
          EXPLORE_PAGING_NUM = 50;
          ISSUE_PAGING_NUM = 50;
          MEMBERS_PAGING_NUM = 50;
          DEFAULT_THEME = "forgejo-dark";
          SHOW_USER_EMAIL = false;
        };
      };
    };
    kyouma.anubis.services."woof.rip" = {
      BIND = "/run/anubis/woof.rip.sock";
      BIND_NETWORK = "unix";
      COOKIE_DOMAIN = "woof.rip";
      DIFFICULTY = 3;
      SOCKET_MODE = "0666";
      SERVE_ROBOTS_TXT = true;
      TARGET = "unix:///run/forgejo/forgejo.sock";
    };
    kyouma.nginx.virtualHosts."woof.rip" = {
      locations."/static/".alias = "${pkgs.forgejo.data}/public/";
      locations."/" = {
        proxyPass = "http://unix:/run/anubis/woof.rip.sock";
      };
    };
    kyouma.restic.paths = [
      "/var/lib/forgejo"
    ];
    security.acme.certs."woof.rip" = {};
  };
}
