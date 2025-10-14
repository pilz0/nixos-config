{
  pkgs,
  ...
}:
{
  networking = {
    useNetworkd = true;
    hostName = "web1_ams1";
    domain = "as214958.net";
    hostId = "4066b435";
  };
  systemd.network = {
    enable = true;
    networks = {
      "10-eth0" = {
        address = [
          "94.142.241.152/31"
          "2a0e:8f02:f017::2/48"
        ];
      };
    };
  };

  networking.extraHosts = ''
    ::1 web1.ams1.as214958.net
    ::1 web1
  '';

  networking.firewall = {
    allowedTCPPorts = [
      22 # ssh
      80 # http
      443 # https
    ];
    allowedUDPPorts = [
    ];
    extraCommands = ''
      ${pkgs.iptables}/bin/ip6tables -A INPUT -p tcp --dport 9100 -i eth0 -s 2a0e:8f02:f017::3 -j ACCEPT
    '';
  };
}
