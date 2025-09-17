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
      sslCertificate = config.age.secrets.cloudflare_cert.path;
      sslCertificateKey = config.age.secrets.cloudflare_key.path;
      locations."/" = {
        proxyPass = "http://localhost:7878";
        proxyWebsockets = true;
      };
    };
    virtualHosts."bazarr.ketamin.trade" = {
      sslCertificate = config.age.secrets.cloudflare_cert.path;
      sslCertificateKey = config.age.secrets.cloudflare_key.path;
      locations."/" = {
        proxyPass = "http://localhost:6767";
        proxyWebsockets = true;
      };
    };
    virtualHosts."sonarr.ketamin.trade" = {
      sslCertificate = config.age.secrets.cloudflare_cert.path;
      sslCertificateKey = config.age.secrets.cloudflare_key.path;
      locations."/" = {
        proxyPass = "http://localhost:8989";
        proxyWebsockets = true;
      };
    };
    virtualHosts."prowlarr.ketamin.trade" = {
      sslCertificate = config.age.secrets.cloudflare_cert.path;
      sslCertificateKey = config.age.secrets.cloudflare_key.path;
      locations."/" = {
        proxyPass = "http://localhost:9696";
        proxyWebsockets = true;
      };
    };
    virtualHosts."readarr.ketamin.trade" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://localhost:8787";
        proxyWebsockets = true;
      };
    };
    virtualHosts."lidarr.ketamin.trade" = {
      sslCertificate = config.age.secrets.cloudflare_cert.path;
      sslCertificateKey = config.age.secrets.cloudflare_key.path;
      locations."/" = {
        proxyPass = "http://localhost:8686";
        proxyWebsockets = true;
      };
    };
    virtualHosts."jellyseerr.ketamin.trade" = {
      sslCertificate = config.age.secrets.cloudflare_cert.path;
      sslCertificateKey = config.age.secrets.cloudflare_key.path;
      locations."/" = {
        proxyPass = "http://localhost:5055";
        proxyWebsockets = true;
      };
    };
    virtualHosts."jellyseerr.dn42.ketamin.trade" = {
      enableACME = false;
      forceSSL = false;
      locations."/" = {
        proxyPass = "http://localhost:5055";
        proxyWebsockets = true;
      };
    };

    virtualHosts."jellyfin.ketamin.trade" = {
      sslCertificate = config.age.secrets.cloudflare_cert.path;
      sslCertificateKey = config.age.secrets.cloudflare_key.path;
      locations."/" = {
        proxyPass = "http://localhost:8096";
        proxyWebsockets = true;
      };
    };
    virtualHosts."jellyfin.dn42.ketamin.trade" = {
      enableACME = false;
      forceSSL = false;
      locations."/" = {
        proxyPass = "http://localhost:8096";
        proxyWebsockets = true;
      };
    };
    virtualHosts."radarr.pilz.foo" = {
      sslCertificate = config.age.secrets.cloudflare_cert.path;
      sslCertificateKey = config.age.secrets.cloudflare_key.path;
      locations."/" = {
        proxyPass = "http://localhost:7878";
        proxyWebsockets = true;
      };
    };
    virtualHosts."radarr.dn42.pilz.foo" = {
      enableACME = false;
      forceSSL = false;
      locations."/" = {
        proxyPass = "http://localhost:7878";
        proxyWebsockets = true;
      };
    };
    virtualHosts."bazarr.pilz.foo" = {
      sslCertificate = config.age.secrets.cloudflare_cert.path;
      sslCertificateKey = config.age.secrets.cloudflare_key.path;
      locations."/" = {
        proxyPass = "http://localhost:6767";
        proxyWebsockets = true;
      };
    };
    virtualHosts."bazarr.dn42.pilz.foo" = {
      enableACME = false;
      forceSSL = false;
      locations."/" = {
        proxyPass = "http://localhost:6767";
        proxyWebsockets = true;
      };
    };
    virtualHosts."sonarr.pilz.foo" = {
      sslCertificate = config.age.secrets.cloudflare_cert.path;
      sslCertificateKey = config.age.secrets.cloudflare_key.path;
      locations."/" = {
        proxyPass = "http://localhost:8989";
        proxyWebsockets = true;
      };
    };
    virtualHosts."sonarr.dn42.pilz.foo" = {
      enableACME = false;
      forceSSL = false;
      locations."/" = {
        proxyPass = "http://localhost:8989";
        proxyWebsockets = true;
      };
    };
    virtualHosts."prowlarr.pilz.foo" = {
      sslCertificate = config.age.secrets.cloudflare_cert.path;
      sslCertificateKey = config.age.secrets.cloudflare_key.path;
      locations."/" = {
        proxyPass = "http://localhost:9696";
        proxyWebsockets = true;
      };
    };
    virtualHosts."prowlarr.dn42.pilz.foo" = {
      sslCertificate = config.age.secrets.cloudflare_cert.path;
      sslCertificateKey = config.age.secrets.cloudflare_key.path;
      locations."/" = {
        proxyPass = "http://localhost:9696";
        proxyWebsockets = true;
      };
    };
    virtualHosts."readarr.pilz.foo" = {
      sslCertificate = config.age.secrets.cloudflare_cert.path;
      sslCertificateKey = config.age.secrets.cloudflare_key.path;
      locations."/" = {
        proxyPass = "http://localhost:8787";
        proxyWebsockets = true;
      };
    };
    virtualHosts."readarr.dn42.pilz.foo" = {
      sslCertificate = config.age.secrets.cloudflare_cert.path;
      sslCertificateKey = config.age.secrets.cloudflare_key.path;
      locations."/" = {
        proxyPass = "http://localhost:8787";
        proxyWebsockets = true;
      };
    };
    virtualHosts."lidarr.pilz.foo" = {
      sslCertificate = config.age.secrets.cloudflare_cert.path;
      sslCertificateKey = config.age.secrets.cloudflare_key.path;
      locations."/" = {
        proxyPass = "http://localhost:8686";
        proxyWebsockets = true;
      };
    };
    virtualHosts."lidarr.dn42.pilz.foo" = {
      enableACME = false;
      forceSSL = false;
      locations."/" = {
        proxyPass = "http://localhost:8686";
        proxyWebsockets = true;
      };
    };
    virtualHosts."jellyseerr.pilz.foo" = {
      sslCertificate = config.age.secrets.cloudflare_cert.path;
      sslCertificateKey = config.age.secrets.cloudflare_key.path;
      locations."/" = {
        proxyPass = "http://localhost:5055";
        proxyWebsockets = true;
      };
    };
    virtualHosts."jellyseerr.dn42.pilz.foo" = {
      enableACME = false;
      forceSSL = false;
      locations."/" = {
        proxyPass = "http://localhost:5055";
        proxyWebsockets = true;
      };
    };
    virtualHosts."jellyfin.pilz.foo" = {
      sslCertificate = config.age.secrets.cloudflare_cert.path;
      sslCertificateKey = config.age.secrets.cloudflare_key.path;
      locations."/" = {
        proxyPass = "http://localhost:8096";
        proxyWebsockets = true;
      };
    };
    virtualHosts."jellyfin.dn42.pilz.foo" = {
      enableACME = false;
      forceSSL = false;
      addSSL = false;
      onlySSL = false;
      locations."/" = {
        proxyPass = "http://localhost:8096";
        proxyWebsockets = true;
      };
    };
  };
}
