{
  ...
}:
{
  imports = [
    ../../profiles/container
    ../../profiles/importAll
    ./proxys.nix
    ./nextcloud.nix
  ];

  pilz = {
    services = {
      tilesproxy.enable = true;
      nginx = {
        enable = true;
        enableMonitoring = true;
      };
    };
    services.testfile.enable = true;
    services.as214958Net.enable = true;
    services.birdLg.frontend.enable = true;
    services.pve-container.network = {
      enable = true;
      address = [
        "94.142.241.152/31"
        "2a0e:8f02:f017::2/64"
      ];
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

  networking = {
    hostName = "web1";
    hostId = "4066b435";
  };

  users.users = {
    snakii = {
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
