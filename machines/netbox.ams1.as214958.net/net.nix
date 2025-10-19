{
  pkgs,
  ...
}:
{
  networking = {
    useNetworkd = true;
    hostName = "netbox";
    domain = "ams1.as214958.net";
    hostId = "10163434";
  };

  systemd.network = {
    networks = {
      "10-eth0" = {
        address = [
          "10.10.10.7/24"
          "2a0e:8f02:f017::7/48"
        ];
      };
    };
  };

  networking.extraHosts = ''
    ::1 netbox.ams1.as214958.net
    ::1 netbox
  '';

  networking.firewall = {
    allowedTCPPorts = [
      22 # ssh
    ];
    allowedUDPPorts = [
    ];
    extraCommands = ''
      ${pkgs.iptables}/bin/ip6tables -A INPUT -p tcp --dport 9100 -i eth0 -s 2a0e:8f02:f017::3 -j ACCEPT
      ${pkgs.iptables}/bin/iptables -A INPUT -p tcp --dport 80 -i eth0 -s 94.142.241.152 -j ACCEPT
      ${pkgs.iptables}/bin/ip6tables -A INPUT -p tcp --dport 80 -i eth0 -s 2a0e:8f02:f017::2 -j ACCEPT
      ${pkgs.iptables}/bin/iptables -A INPUT -p tcp --dport 443 -i eth0 -s 94.142.241.152 -j ACCEPT
      ${pkgs.iptables}/bin/ip6tables -A INPUT -p tcp --dport 443 -i eth0 -s 2a0e:8f02:f017::2 -j ACCEPT
      ${pkgs.iptables}/bin/iptables -A INPUT -p tcp --dport 8001 -i eth0 -s 94.142.241.152 -j ACCEPT
      ${pkgs.iptables}/bin/ip6tables -A INPUT -p tcp --dport 8001 -i eth0 -s 2a0e:8f02:f017::2 -j ACCEPT
    '';
  };
}
