{
  ...
}:
{
  imports = [
    ../../profiles/container
    ../../modules/services/nginx
    ../../modules/services/testfile
    ../../modules/services/as214958-net
    ../../modules/services/bird-lg-frontend
    ./proxys.nix
    ./promtail-nginx.nix
  ];

  pilz = {
    services.testfile.enable = true;
    services.as214958Net.enable = true;
    services.birdLg.frontend.enable = true;
    services.pve-container.network = {
      enable = true;
      address = [
        "94.142.241.152/31"
        "2a0e:8f02:f017::2/48"
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
