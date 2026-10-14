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
