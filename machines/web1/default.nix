{
  ...
}:
{
  imports = [
    ../../modules/container
    ../../modules/services/nginx
    ../../modules/services/testfile
    ../../modules/services/as214958-net
    ../../modules/container/network.nix
    ../../modules/services/bird-lg-frontend
    ../../modules/nixos-builder-client
    ./proxys.nix
    ./promtail-nginx.nix
  ];

  pilz = {
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

  systemd.network.networks."10-eth0".address = [
    "94.142.241.152/31"
    "2a0e:8f02:f017::2/48"
  ];

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
