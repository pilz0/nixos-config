{ config, ... }:

{
  age.secrets.nixarr-wg = {
    file = ../../secrets/nixarr-wg.age;
    owner = "nixarr";
    group = "nixarr";
  };

  nixarr = {
    enable = true;
    mediaDir = "/data/";
    stateDir = "/data/media/.state/nixarr";

    vpn = {
      enable = true;
      wgConf = config.age.secrets.nixarr-wg.path;
    };

    transmission = {
      enable = true;
      vpn.enable = true;
      peerPort = 63993; # Set this to the port forwarded by your VPN
      extraSettings = {
        speed-limit-up-enabled = true;
        speed-limit-up = 700;
      };
    };

    bazarr.enable = true;
    lidarr.enable = true;
    prowlarr.enable = true;
    radarr.enable = true;
    readarr.enable = true;
    sonarr.enable = true; # I FUCKING HATE SONARR
  };
  #  recyclarr.enable = false;

  services.jellyseerr.enable = true;
  services.jellyfin.enable = true;

  services.nginx = {
    virtualHosts."radarr.ketamin.trade" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://localhost:7878";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };
    };
    virtualHosts."bazarr.ketamin.trade" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://localhost:6767";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };
    };
    virtualHosts."sonarr.ketamin.trade" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://localhost:8989";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };
    };
    virtualHosts."prowlarr.ketamin.trade" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://localhost:9696";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };
    };
    virtualHosts."readarr.ketamin.trade" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://localhost:8787";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };
    };
    virtualHosts."lidarr.ketamin.trade" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://localhost:8686";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };
    };
    virtualHosts."jellyseerr.ketamin.trade" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://localhost:5055";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };
    };
    virtualHosts."jellyseerr.dn42.ketamin.trade" = {
      enableACME = false;
      forceSSL = false;
      locations."/" = {
        proxyPass = "http://localhost:5055";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };
    };

    virtualHosts."jellyfin.ketamin.trade" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://localhost:8096";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };
    };
    virtualHosts."jellyfin.dn42.ketamin.trade" = {
      enableACME = false;
      forceSSL = false;
      locations."/" = {
        proxyPass = "http://localhost:8096";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };
    };
    virtualHosts."radarr.pilz.foo" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://localhost:7878";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };
    };
    virtualHosts."radarr.dn42.pilz.foo" = {
      enableACME = false;
      forceSSL = false;
      locations."/" = {
        proxyPass = "http://localhost:7878";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };
    };
    virtualHosts."bazarr.pilz.foo" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://localhost:6767";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };
    };
    virtualHosts."bazarr.dn42.pilz.foo" = {
      enableACME = false;
      forceSSL = false;
      locations."/" = {
        proxyPass = "http://localhost:6767";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };
    };
    virtualHosts."sonarr.pilz.foo" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://localhost:8989";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };
    };
    virtualHosts."sonarr.dn42.pilz.foo" = {
      enableACME = false;
      forceSSL = false;
      locations."/" = {
        proxyPass = "http://localhost:8989";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };
    };
    virtualHosts."prowlarr.pilz.foo" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://localhost:9696";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };
    };
    virtualHosts."prowlarr.dn42.pilz.foo" = {
      enableACME = false;
      forceSSL = false;
      locations."/" = {
        proxyPass = "http://localhost:9696";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };
    };
    virtualHosts."readarr.pilz.foo" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://localhost:8787";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };
    };
    virtualHosts."readarr.dn42.pilz.foo" = {
      enableACME = false;
      forceSSL = false;
      locations."/" = {
        proxyPass = "http://localhost:8787";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };
    };
    virtualHosts."lidarr.pilz.foo" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://localhost:8686";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };
    };
    virtualHosts."lidarr.dn42.pilz.foo" = {
      enableACME = false;
      forceSSL = false;
      locations."/" = {
        proxyPass = "http://localhost:8686";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };
    };
    virtualHosts."jellyseerr.pilz.foo" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://localhost:5055";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };
    };
    virtualHosts."jellyseerr.dn42.pilz.foo" = {
      enableACME = false;
      forceSSL = false;
      locations."/" = {
        proxyPass = "http://localhost:5055";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };
    };
    virtualHosts."jellyfin.pilz.foo" = {
      sslCertificate = config.age.secrets.cloudflare_cert.path;
      sslCertificateKey = config.age.secrets.cloudflare_key.path;
      locations."/" = {
        proxyPass = "http://localhost:8096";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };
    };
    virtualHosts."jellyfin.dn42.pilz.foo" = {
      enableACME = false;
      forceSSL = false;
      addSSL = false;
      onlySSL = false;
      locations."/" = {
        proxyPass = "http://localhost:8096";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };
    };
  };
}
