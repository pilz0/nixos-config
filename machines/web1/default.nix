{
  ...
}:
{
  imports = [
    ../../profiles/container
    ../../modules/services/vaultwarden
    ./proxys.nix
  ];

  pilz = {
    services = {
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
    lxc = {
      enable = true;
      ctID = "100";
    };
  };

  mira.services.vaultwarden.enable = true;
  kyouma.restic = {
    enable = true;
    remoteUser = "zh3485s3";
    timerConfig = {
      OnCalender = "0,6,12,18:00:00";
      Persistent = true;
    };
  };

  networking = {
    hostName = "web1";
    hostId = "4066b435";
  };

  users.users = {
    emily = {
      extraGroups = [
        "wheel"
      ];
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA/+iN407+HsfHbbC3tfdA8Yf4TZ08qXQMb4tb/SDAs+"
      ];
    };
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
