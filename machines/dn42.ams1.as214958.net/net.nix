{
  pkgs,
  ...
}:
{
  networking = {
    hostName = "dn42";
    hostId = "40163434";
  };

  systemd.network = {
    networks = {
      "10-eth0" = {
        address = [
          "10.10.10.6/24"
          "2a0e:8f02:f017::6/48"
        ];
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [
    ];
    allowedUDPPorts = [
    ];
    extraCommands = ''
      ${pkgs.iptables}/bin/iptables -A INPUT -p tcp --dport 18000 -i eth0 -s 94.142.241.152 -j ACCEPT
      ${pkgs.iptables}/bin/ip6tables -A INPUT -p tcp --dport 18000 -i eth0 -s 2a0e:8f02:f017::2 -j ACCEPT
    '';
  };
}
