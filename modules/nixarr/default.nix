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

  services = {
    jellyfin = {
      enable = true;
    };
    jellyseerr = {
      enable = true;
    };

    services.nginx = {
      virtualHosts = {
        "radarr.ketamin.trade" = {
          sslCertificate = config.age.secrets.cloudflare_cert.path;
          sslCertificateKey = config.age.secrets.cloudflare_key.path;
          locations."/" = {
            proxyPass = "http://localhost:7878";
            proxyWebsockets = true;
          };
        };
        "bazarr.ketamin.trade" = {
          sslCertificate = config.age.secrets.cloudflare_cert.path;
          sslCertificateKey = config.age.secrets.cloudflare_key.path;
          locations."/" = {
            proxyPass = "http://localhost:6767";
            proxyWebsockets = true;
          };
        };
        "sonarr.ketamin.trade" = {
          sslCertificate = config.age.secrets.cloudflare_cert.path;
          sslCertificateKey = config.age.secrets.cloudflare_key.path;
          locations."/" = {
            proxyPass = "http://localhost:8989";
            proxyWebsockets = true;
          };
        };
        "prowlarr.ketamin.trade" = {
          sslCertificate = config.age.secrets.cloudflare_cert.path;
          sslCertificateKey = config.age.secrets.cloudflare_key.path;
          locations."/" = {
            proxyPass = "http://localhost:9696";
            proxyWebsockets = true;
          };
        };
        "readarr.ketamin.trade" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://localhost:8787";
            proxyWebsockets = true;
          };
        };
        "lidarr.ketamin.trade" = {
          sslCertificate = config.age.secrets.cloudflare_cert.path;
          sslCertificateKey = config.age.secrets.cloudflare_key.path;
          locations."/" = {
            proxyPass = "http://localhost:8686";
            proxyWebsockets = true;
          };
        };
        "jellyseerr.ketamin.trade" = {
          sslCertificate = config.age.secrets.cloudflare_cert.path;
          sslCertificateKey = config.age.secrets.cloudflare_key.path;
          locations."/" = {
            proxyPass = "http://localhost:5055";
            proxyWebsockets = true;
          };
        };
        "jellyseerr.dn42.ketamin.trade" = {
          enableACME = false;
          forceSSL = false;
          locations."/" = {
            proxyPass = "http://localhost:5055";
            proxyWebsockets = true;
          };
        };

        "jellyfin.ketamin.trade" = {
          sslCertificate = config.age.secrets.cloudflare_cert.path;
          sslCertificateKey = config.age.secrets.cloudflare_key.path;
          locations."/" = {
            proxyPass = "http://localhost:8096";
            proxyWebsockets = true;
          };
        };
        "jellyfin.dn42.ketamin.trade" = {
          enableACME = false;
          forceSSL = false;
          locations."/" = {
            proxyPass = "http://localhost:8096";
            proxyWebsockets = true;
          };
        };
        "radarr.pilz.foo" = {
          sslCertificate = config.age.secrets.cloudflare_cert.path;
          sslCertificateKey = config.age.secrets.cloudflare_key.path;
          locations."/" = {
            proxyPass = "http://localhost:7878";
            proxyWebsockets = true;
          };
        };
        "radarr.dn42.pilz.foo" = {
          enableACME = false;
          forceSSL = false;
          locations."/" = {
            proxyPass = "http://localhost:7878";
            proxyWebsockets = true;
          };
        };
        "bazarr.pilz.foo" = {
          sslCertificate = config.age.secrets.cloudflare_cert.path;
          sslCertificateKey = config.age.secrets.cloudflare_key.path;
          locations."/" = {
            proxyPass = "http://localhost:6767";
            proxyWebsockets = true;
          };
        };
        "bazarr.dn42.pilz.foo" = {
          enableACME = false;
          forceSSL = false;
          locations."/" = {
            proxyPass = "http://localhost:6767";
            proxyWebsockets = true;
          };
        };
        "sonarr.pilz.foo" = {
          sslCertificate = config.age.secrets.cloudflare_cert.path;
          sslCertificateKey = config.age.secrets.cloudflare_key.path;
          locations."/" = {
            proxyPass = "http://localhost:8989";
            proxyWebsockets = true;
          };
        };
        "sonarr.dn42.pilz.foo" = {
          enableACME = false;
          forceSSL = false;
          locations."/" = {
            proxyPass = "http://localhost:8989";
            proxyWebsockets = true;
          };
        };
        "prowlarr.pilz.foo" = {
          sslCertificate = config.age.secrets.cloudflare_cert.path;
          sslCertificateKey = config.age.secrets.cloudflare_key.path;
          locations."/" = {
            proxyPass = "http://localhost:9696";
            proxyWebsockets = true;
          };
        };
        "prowlarr.dn42.pilz.foo" = {
          sslCertificate = config.age.secrets.cloudflare_cert.path;
          sslCertificateKey = config.age.secrets.cloudflare_key.path;
          locations."/" = {
            proxyPass = "http://localhost:9696";
            proxyWebsockets = true;
          };
        };
        "readarr.pilz.foo" = {
          sslCertificate = config.age.secrets.cloudflare_cert.path;
          sslCertificateKey = config.age.secrets.cloudflare_key.path;
          locations."/" = {
            proxyPass = "http://localhost:8787";
            proxyWebsockets = true;
          };
        };
        "readarr.dn42.pilz.foo" = {
          sslCertificate = config.age.secrets.cloudflare_cert.path;
          sslCertificateKey = config.age.secrets.cloudflare_key.path;
          locations."/" = {
            proxyPass = "http://localhost:8787";
            proxyWebsockets = true;
          };
        };
        "lidarr.pilz.foo" = {
          sslCertificate = config.age.secrets.cloudflare_cert.path;
          sslCertificateKey = config.age.secrets.cloudflare_key.path;
          locations."/" = {
            proxyPass = "http://localhost:8686";
            proxyWebsockets = true;
          };
        };
        "lidarr.dn42.pilz.foo" = {
          enableACME = false;
          forceSSL = false;
          locations."/" = {
            proxyPass = "http://localhost:8686";
            proxyWebsockets = true;
          };
        };
        "jellyseerr.pilz.foo" = {
          sslCertificate = config.age.secrets.cloudflare_cert.path;
          sslCertificateKey = config.age.secrets.cloudflare_key.path;
          locations."/" = {
            proxyPass = "http://localhost:5055";
            proxyWebsockets = true;
          };
        };
        "jellyseerr.dn42.pilz.foo" = {
          enableACME = false;
          forceSSL = false;
          locations."/" = {
            proxyPass = "http://localhost:5055";
            proxyWebsockets = true;
          };
        };
        "jellyfin.pilz.foo" = {
          sslCertificate = config.age.secrets.cloudflare_cert.path;
          sslCertificateKey = config.age.secrets.cloudflare_key.path;
          locations."/" = {
            proxyPass = "http://localhost:8096";
            proxyWebsockets = true;
          };
        };
        "jellyfin.dn42.pilz.foo" = {
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
    };
  };
}
