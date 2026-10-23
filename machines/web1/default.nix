{
  ...
}:
{
  imports = [
    ../../profiles/vm
    ../../profiles/mira
    ./proxys.nix
  ];

  pilz = {
    services = {
      syncserver.enable = true;
      flohannes-de.enable = true;
      diyhrt-web.enable = true;
      timemachine-server.enable = true;
      nextcloud.enable = true;
      tilesproxy.enable = true;
      nginx = {
        enable = true;
        enableMonitoring = true;
      };
      testfile.enable = true;
      as214958Net.enable = true;
      birdLg.frontend.enable = true;
      pve-container.network = {
        enable = true;
        address = [
          "94.142.241.152/31"
          "2a0e:8f02:f017::2/64"
        ];
      };
    };
    deployment = {
      targetHost = "web1.ams1.as214958.net";
      tags = [ "infra" ];
    };
  };

  mira.services = {
    vaultwarden.enable = true;
    forgejo.enable = true;
  };
  kyouma.restic = {
    enable = true;
    remoteUser = "zh3485s3";
    backupPostgresql = true;
    timerConfig = {
      OnCalender = "0,6,12,18:00:00";
      Persistent = true;
    };
  };

  # TODO: drop once nixos-unstable has php 8.4.27/8.5.12 (NixOS/nixpkgs#576853)
  # CVE-2026-109618, CVE-2026-109619
  nixpkgs.overlays = [
    (
      final: prev:
      let
        bump =
          php: version: hash:
          (php.overrideAttrs {
            inherit version;
            src = final.fetchurl {
              url = "https://www.php.net/distributions/php-${version}.tar.bz2";
              inherit hash;
            };
          }).withExtensions
            (
              { enabled, ... }:
              map (
                ext:
                # new OOM tests need the filter extension loaded explicitly
                if ext.extensionName == "filter" then
                  ext.overrideAttrs (old: {
                    postConfigure = (old.postConfigure or "") + ''
                      substituteInPlace \
                        tests/oom_filter_input.phpt \
                        tests/oom_filter_input_array.phpt \
                        tests/oom_filter_default_encoded.phpt \
                        --replace-fail "'-n'," "'-n', '-d', 'extension=$PWD/modules/filter.so',"
                    '';
                  })
                else
                  ext
              ) enabled
            );
      in
      {
        php84 = bump prev.php84 "8.4.27" "sha256-slMKh3xyL0sIyeF0owywi6wrfhkD7m6eMV8KqfX4LCQ=";
        php85 = bump prev.php85 "8.5.12" "sha256-/7YO3EN87WO1E35JhNs3moERxQBJxxFRDYuVgnfvwag=";
      }
    )
  ];

  system.stateVersion = "23.11";

  networking = {
    hostName = "web1";
    domain = "ams1.as214958.net";
    hostId = "4066b435";
  };

  networking.firewall = {
    allowedTCPPorts = [
      80
      443
    ];
    allowedUDPPorts = [
    ];
  };
  virtualisation.docker.enable = true;
}
