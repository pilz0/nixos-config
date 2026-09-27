{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
let
  wp4nix = pkgs.callPackage inputs.wp4nix { };
  cfg = config.pilz.services.flohannes-de;
in
{
  options.pilz.services.flohannes-de = {
    enable = lib.mkEnableOption "";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [
      (self: super: {
        wordpress = super.wordpress.overrideAttrs (oldAttrs: rec {
          installPhase = oldAttrs.installPhase + ''
            ln -s /var/lib/wordpress/flohannes.de/webp-express $out/share/wordpress/wp-content/webp-express
          '';
        });
      })
    ];

    systemd.tmpfiles.rules = [
      "d '/var/lib/wordpress/flohannes.de/webp-express' 0750 wordpress wwwrun - -"
    ];

    services.wordpress = {
      webserver = "nginx";
      sites."flohannes.de" = {
        database.socket = "/run/mysqld/mysqld.sock";
        package = pkgs.wordpress_7_1;
        plugins = {
          inherit (wp4nix.plugins)
            disable-xml-rpc
            wordpress-seo
            leaflet-map
            simple-cloudflare-turnstile
            webp-express
            static-mail-sender-configurator
            contact-form-7
            ;
        };
        themes = {
          inherit (wp4nix.themes)
            twentysixteen
            ;
        };
        languages = [ pkgs.wordpressPackages.languages.de_DE ];
        settings = {
          WPLANG = "de_DE";
          FORCE_SSL_ADMIN = true;
          WP_DEBUG = true;
          WP_DEBUG_LOG = true;
          WP_MAIL_FROM = "info@flohannes.de";
        };
        extraConfig = ''
          $_SERVER['HTTPS'] = 'on';
          ini_set( 'error_log', '/var/lib/wordpress/flohannes.de/debug.log' );
        '';
      };
    };

    services.nginx.virtualHosts."flohannes.de" = {
      enableACME = true;
      forceSSL = true;
    };

    age.secrets.smtp-flohannes = {
      file = ../../../secrets/smtp-flohannes.age;
      owner = "wordpress";
      group = "nginx";
      mode = "500";
    };

    programs.msmtp = {
      enable = true;
      accounts.default = {
        auth = true;
        tls = true;
        host = "smtp.eu.mailgun.org";
        from = "info@flohannes.de";
        user = "info@flohannes.de";
        passwordeval = "cat ${config.age.secrets.smtp-flohannes.path}";
      };
    };
  };
}
