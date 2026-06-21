{
  pkgs,
  ...
}:
{
  imports = [
    ../../profiles/container
  ];

  pilz = {
    services.pve-container.network = {
      enable = true;
      address = [
        "10.10.10.16/24"
        "2a0e:8f02:f017::26/64"
      ];
    };
    deployment = {
      targetHost = "nextcloud.ams1.as214958.net";
      tags = [ "infra" ];
    };
    lxc = {
      enable = true;
      ctID = "102";
    };
  };

  networking = {
    hostName = "nextcloud";
    hostId = "4e633223";
  };

  networking.firewall = {
    allowedTCPPorts = [
    ];
    allowedUDPPorts = [
    ];
    extraCommands = ''
      ${pkgs.iptables}/bin/iptables -A INPUT -p tcp -s 94.142.241.152 -j ACCEPT
      ${pkgs.iptables}/bin/ip6tables -A INPUT -p tcp -s 2a0e:8f02:f017::2 -j ACCEPT
    '';
  };
}
