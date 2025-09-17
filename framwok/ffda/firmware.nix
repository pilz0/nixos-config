{
  pkgs,
  config,
  ...
}:
{
  services.nginx.enable = true;

  environment.etc = {
    "firmware_freifunk_net/config.js" = {
      source = ./files/fireware_darmstadt_freifunk_net_config.js;
      mode = "0755";
      group = config.services.nginx.group;
      user = config.services.nginx.user;
    };
  };

  systemd.services.firmware-darmstadt-freifunk-net-pull = {
    enable = true;
    description = "Pull firmware.darmstadt.freifunk.net from github";
    script = ''
      if [ ! -d /srv/www/gluon-firmware-selector/ ]; then
        mkdir -p /srv/www/
        ${pkgs.git}/bin/git -C /srv/www/ clone https://github.com/freifunk-darmstadt/gluon-firmware-selector
      fi
      ${pkgs.git}/bin/git -C /srv/www/gluon-firmware-selector/ pull

      yes | cp -rf /etc/firmware_freifunk_net/config.js /srv/www/gluon-firmware-selector/config.js
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };

  systemd.timers."firmware-darmstadt-freifunk-net-pull" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "20m";
      OnUnitActiveSec = "12h";
      Unit = "firmware-darmstadt-freifunk-net-pull.service";
    };
  };

  users.users.ffda_firmware = {
    isSystemUser = true;
    group = "nginx";
    description = "User to push files from CI-Pipelines";
    useDefaultShell = true;
    createHome = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII1mECV9Etr/nLIgg1E2mpFvAW1RexhhsRKrF7XcDEZI marie@framwok" # for testing
    ];
    home = "/srv/firmware";
  };

  systemd.tmpfiles.rules = [
    "d /srv/firmware 0755 ffda_firmware nginx -"
  ];

  services.nginx = {
    virtualHosts = {
      "localhost" = {
        root = "/srv/www/gluon-firmware-selector/";
        #        forceSSL = true;
        #        enableACME = true;
        extraConfig = ''
          add_header Content-Security-Policy "default-src 'none'; script-src 'self'; style-src 'self'; img-src 'self'; connect-src 'self';";
          add_header X-Frame-Options "DENY";
        '';

        locations = {
          "/archive/" = {
            alias = "/srv/firmware/archive/";
            extraConfig = "autoindex on;";
          };
          "/images/" = {
            alias = "/srv/firmware/images/";
            extraConfig = "autoindex on;";
          };
          "/modules/" = {
            alias = "/srv/firmware/modules/";
            extraConfig = "autoindex on;";
          };
          "/openlayers/" = {
            alias = "/srv/firmware/openlayers/";
            extraConfig = "autoindex on;";
          };
        };
      };
    };
  };
}
  