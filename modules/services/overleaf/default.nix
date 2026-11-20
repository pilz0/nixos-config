{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.pilz.services.overleaf;
  docker = lib.getExe config.virtualisation.docker.package;
  network = "overleaf";
  # the stock image ships a minimal texlive scheme (no extarticle.cls etc.), so build a local
  # image on top of it with the full scheme. The tag is keyed on the base image and the
  # dockerfile, so upgrades and recipe changes rebuild.
  runImage = "overleaf-run:current";
  # tlmgr's own post-install actions are broken for scheme-full (fmtutil: "multiple commands
  # found"), so install with --no-execute-actions and replay what matters by hand: enable every
  # font map from the tlpdb (without this pdftex falls back to bitmap fonts and microtype fails
  # with "auto expansion is only possible with scalable fonts"), then rebuild the hyphenation
  # config and all formats.
  dockerfileText = ''
    FROM ${cfg.image}
    RUN tlmgr update --self \
     && tlmgr install --no-execute-actions scheme-full \
     && texhash
    RUN db=$(ls /usr/local/texlive/*/tlpkg/texlive.tlpdb) \
     && args=$(grep -h '^execute add' "$db" | awk '/addMap /{printf " --enable Map=%s",$3} /addMixedMap /{printf " --enable MixedMap=%s",$3} /addKanjiMap /{printf " --enable KanjiMap=%s",$3}') \
     && updmap-sys --nomkmap $args \
     && updmap-sys \
     && tlmgr generate language \
     && fmtutil-sys --all \
     && tlmgr path add
  '';
  localImage = "overleaf-full:${
    builtins.substring 0 12 (builtins.hashString "sha256" "${cfg.image}${dockerfileText}")
  }";
  dockerfile = pkgs.writeText "Dockerfile.overleaf-full" dockerfileText;
in
{
  # Admin user (first run):
  #   docker exec overleaf /bin/bash -c "cd /overleaf/services/web && \
  #     node modules/server-ce-scripts/scripts/create-user --admin --email=you@example.com"
  options.pilz.services.overleaf = {
    enable = lib.mkEnableOption "overleaf community edition (not packaged in nixpkgs, so this runs the upstream oci images)";
    domain = lib.mkOption {
      type = lib.types.nonEmptyStr;
      default = "overleaf.pilz.foo";
    };
    image = lib.mkOption {
      type = lib.types.nonEmptyStr;
      default = "docker.io/sharelatex/sharelatex:6.3.3";
    };
    fullTexlive = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Build a local image with the full TeX Live scheme (several GB, first build takes a long time)";
    };
    mongoImage = lib.mkOption {
      type = lib.types.nonEmptyStr;
      default = "docker.io/library/mongo:8.0";
    };
    redisImage = lib.mkOption {
      type = lib.types.nonEmptyStr;
      default = "docker.io/library/redis:7.4";
    };
    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/overleaf";
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 8085;
      description = "Loopback port the overleaf container is published on";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker.enable = true;
    virtualisation.oci-containers = {
      backend = "docker";
      containers = {
        overleaf-mongo = {
          image = cfg.mongoImage;
          cmd = [
            "--replSet"
            "overleaf"
            "--bind_ip_all"
          ];
          volumes = [ "${cfg.dataDir}/mongo:/data/db" ];
          extraOptions = [
            "--network=${network}"
            "--network-alias=overleaf-mongo"
          ];
        };
        overleaf-redis = {
          image = cfg.redisImage;
          volumes = [ "${cfg.dataDir}/redis:/data" ];
          extraOptions = [ "--network=${network}" ];
        };
        overleaf = {
          image = if cfg.fullTexlive then runImage else cfg.image;
          dependsOn = [
            "overleaf-mongo"
            "overleaf-redis"
          ];
          environmentFiles = [ "${cfg.dataDir}/secrets.env" ];
          ports = [ "127.0.0.1:${toString cfg.port}:80" ];
          volumes = [ "${cfg.dataDir}/sharelatex:/var/lib/overleaf" ];
          extraOptions = [ "--network=${network}" ];
          environment = {
            OVERLEAF_APP_NAME = "Overleaf";
            OVERLEAF_SITE_URL = "https://${cfg.domain}";
            OVERLEAF_MONGO_URL = "mongodb://overleaf-mongo:27017/sharelatex?replicaSet=overleaf";
            OVERLEAF_REDIS_HOST = "overleaf-redis";
            REDIS_HOST = "overleaf-redis";
            ENABLED_LINKED_FILE_TYPES = "project_file,project_output_file";
            ENABLE_CONVERSIONS = "true";
            OVERLEAF_BEHIND_PROXY = "true";
            OVERLEAF_SECURE_COOKIE = "true";
          };
        };
      };
    };

    systemd.services = {
      overleaf-network = {
        description = "docker network for overleaf";
        wantedBy = [ "multi-user.target" ];
        after = [ "docker.service" ];
        requires = [ "docker.service" ];
        before = [
          "docker-overleaf-mongo.service"
          "docker-overleaf-redis.service"
          "docker-overleaf.service"
        ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''
          ${docker} network inspect ${network} >/dev/null 2>&1 || ${docker} network create ${network}
        '';
      };

      # mongo must be a (single node) replica set for overleaf; initiation is idempotent
      overleaf-mongo-init = {
        description = "initiate overleaf mongo replica set";
        wantedBy = [ "multi-user.target" ];
        after = [ "docker-overleaf-mongo.service" ];
        requires = [ "docker-overleaf-mongo.service" ];
        before = [ "docker-overleaf.service" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''
          for _ in $(seq 60); do
            ${docker} exec overleaf-mongo mongosh --quiet --eval 'db.adminCommand("ping")' >/dev/null 2>&1 && break
            sleep 2
          done
          ${docker} exec overleaf-mongo mongosh --quiet --eval \
            'try { rs.status().ok } catch (e) { rs.initiate({_id: "overleaf", members: [{_id: 0, host: "overleaf-mongo:27017"}]}) }'
        '';
      };

      docker-overleaf-mongo = {
        after = [ "overleaf-network.service" ];
        requires = [ "overleaf-network.service" ];
      };
      docker-overleaf-redis = {
        after = [ "overleaf-network.service" ];
        requires = [ "overleaf-network.service" ];
      };
      # persistent random secrets required by overleaf >= 6; generated once, kept in dataDir
      overleaf-secrets = {
        description = "generate overleaf secrets";
        wantedBy = [ "multi-user.target" ];
        before = [ "docker-overleaf.service" ];
        unitConfig.ConditionPathExists = "!${cfg.dataDir}/secrets.env";
        serviceConfig = {
          Type = "oneshot";
          UMask = "0077";
        };
        path = [ pkgs.openssl ];
        script = ''
          echo "OVERLEAF_INVITE_TOKEN_SECRET=$(openssl rand -base64 32)" > ${cfg.dataDir}/secrets.env
        '';
      };

      overleaf-image = lib.mkIf cfg.fullTexlive {
        description = "build overleaf image with full texlive";
        after = [
          "docker.service"
          "network-online.target"
        ];
        wants = [ "network-online.target" ];
        requires = [ "docker.service" ];
        before = [ "docker-overleaf.service" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          TimeoutStartSec = "infinity";
        };
        # the container runs a stable tag. If the build fails, fall back to the stock image so
        # overleaf stays up (with the minimal texlive) and this unit shows as failed
        script = ''
          if ! ${docker} image inspect ${localImage} >/dev/null 2>&1; then
            ${docker} build -t ${localImage} - < ${dockerfile} || {
              ${docker} image inspect ${runImage} >/dev/null 2>&1 || {
                ${docker} image inspect ${cfg.image} >/dev/null 2>&1 || ${docker} pull ${cfg.image}
                ${docker} tag ${cfg.image} ${runImage}
              }
              exit 1
            }
          fi
          ${docker} tag ${localImage} ${runImage}
          ${pkgs.systemd}/bin/systemctl try-restart docker-overleaf.service || true
        '';
      };

      docker-overleaf = {
        after = [
          "overleaf-mongo-init.service"
          "overleaf-secrets.service"
        ]
        ++ lib.optional cfg.fullTexlive "overleaf-image.service";
        # wants, not requires: a failed image build must not take overleaf down
        wants = lib.optional cfg.fullTexlive "overleaf-image.service";
        requires = [
          "overleaf-mongo-init.service"
          "overleaf-secrets.service"
        ];
      };
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0755 root root -"
      "d ${cfg.dataDir}/mongo 0750 root root -"
      "d ${cfg.dataDir}/redis 0750 root root -"
      "d ${cfg.dataDir}/sharelatex 0750 root root -"
    ];

    services.nginx.virtualHosts.${cfg.domain} = {
      enableACME = true;
      forceSSL = true;
      http3 = true;
      quic = true;
      extraConfig = ''
        client_max_body_size 50M;
      '';
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.port}";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_read_timeout 3m;
          proxy_send_timeout 3m;
        '';
      };
    };
  };
}
