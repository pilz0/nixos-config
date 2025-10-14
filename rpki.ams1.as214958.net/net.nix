{
  pkgs,
  ...
}:
{
  networking = {
    useNetworkd = true;
    hostName = "rpki";
    domain = "as214958.net";
    hostId = "4066312d";
  };

  systemd.network = {
    networks = {
      "10-eth0" = {
        address = [
          "10.10.10.5/24"
          "2a0e:8f02:f017::5/48"
        ];
      };
    };
  };

  networking.extraHosts = ''
    ::1 rpki.ams1.as214958.net
    ::1 rpki
  '';

  networking.firewall = {
    allowedTCPPorts = [
      22 # ssh
    ];
    allowedUDPPorts = [
    ];
    extraCommands = ''
      ${pkgs.iptables}/bin/ip6tables -A INPUT -p tcp --dport 9100 -i eth0 -s 2a0e:8f02:f017::3 -j ACCEPT
      ${pkgs.iptables}/bin/iptables -A INPUT -p tcp --dport 3323 -i eth0 -s 94.142.240.36 -j ACCEPT
      ${pkgs.iptables}/bin/ip6tables -A INPUT -p tcp --dport 3323 -i eth0 -s 2a02:898:0:20::427:1 -j ACCEPT
      ${pkgs.iptables}/bin/iptables -A INPUT -p tcp --dport 8323 -i eth0 -s 94.142.240.36 -j ACCEPT
      ${pkgs.iptables}/bin/ip6tables -A INPUT -p tcp --dport 8323 -i eth0 -s 2a02:898:0:20::427:1 -j ACCEPT
      ${pkgs.iptables}/bin/iptables -A INPUT -p tcp --dport 3323 -i eth0 -s 10.10.10.1 -j ACCEPT
      ${pkgs.iptables}/bin/ip6tables -A INPUT -p tcp --dport 3323 -i eth0 -s 2a0e:8f02:f017::3 -j ACCEPT
      ${pkgs.iptables}/bin/iptables -A INPUT -p tcp --dport 8323 -i eth0 -s 10.10.10.1 -j ACCEPT
      ${pkgs.iptables}/bin/ip6tables -A INPUT -p tcp --dport 8323 -i eth0 -s 2a0e:8f02:f017::3 -j ACCEPT
    '';
  };
}
