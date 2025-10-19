{
  pkgs,
  ...
}:
{
  networking = {
    hostName = "grafana";
    hostId = "4066b432";
  };

  systemd.network = {
    networks = {
      "10-eth0" = {
        address = [
          "10.10.10.3/24"
          "2a0e:8f02:f017::3/48"
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
      ${pkgs.iptables}/bin/ip6tables -A INPUT -p tcp --dport 9092 -i eth0 -s 2a0e:8f02:f017::1 -j ACCEPT
      ${pkgs.iptables}/bin/ip6tables -A INPUT -p tcp --dport 9092 -i eth0 -s 2a02:898:0:20::427:1 -j ACCEPT
      ${pkgs.iptables}/bin/iptables -A INPUT -p tcp --dport 3001 -i eth0 -s 94.142.241.152 -j ACCEPT
      ${pkgs.iptables}/bin/ip6tables -A INPUT -p tcp --dport 3001 -i eth0 -s 2a0e:8f02:f017::2 -j ACCEPT
    '';
  };
}
