{
  pkgs,
  ...
}:
{
  imports = [
    ../../profiles/container
    ../../modules/services/netbox
  ];

  pilz = {
    services.pve-container.network = {
      enable = true;
      address = [
        "10.10.10.7/24"
        "2a0e:8f02:f017::7/48"
      ];
    };
    deployment = {
      targetHost = "netbox.ams1.as214958.net";
      tags = [ "infra" ];
    };
    lxc = {
      enable = true;
      ctID = "105";
    };
  };

  networking = {
    hostName = "netbox";
    hostId = "10163434";
  };

  networking.firewall = {
    allowedTCPPorts = [
    ];
    allowedUDPPorts = [
    ];
    extraCommands = ''
      ${pkgs.iptables}/bin/ip6tables -A INPUT -p tcp --dport 9100 -s 2a0e:8f02:f017::3 -j ACCEPT
      ${pkgs.iptables}/bin/iptables -A INPUT -p tcp --dport 80 -s 94.142.241.152 -j ACCEPT
      ${pkgs.iptables}/bin/ip6tables -A INPUT -p tcp --dport 80 -s 2a0e:8f02:f017::2 -j ACCEPT
      ${pkgs.iptables}/bin/iptables -A INPUT -p tcp --dport 443 -s 94.142.241.152 -j ACCEPT
      ${pkgs.iptables}/bin/ip6tables -A INPUT -p tcp --dport 443 -s 2a0e:8f02:f017::2 -j ACCEPT
      ${pkgs.iptables}/bin/iptables -A INPUT -p tcp --dport 8001 -s 94.142.241.152 -j ACCEPT
      ${pkgs.iptables}/bin/ip6tables -A INPUT -p tcp --dport 8001 -s 2a0e:8f02:f017::2 -j ACCEPT
    '';
  };
}
