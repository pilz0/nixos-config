{
  pkgs,
  ...
}:
{
  imports = [
    ../../modules/container
    ../../modules/container/network.nix
    ../../modules/nixos-builder-client
    ../../modules/services/routinator
    ../../modules/common
  ];

  pilz = {
    deployment = {
      targetHost = "rpki.ams1.as214958.net";
      tags = [ "infra" ];
    };
    lxc = {
      enable = true;
      ctID = "102";
    };
  };

  networking = {
    hostName = "rpki";
    hostId = "4066312d";
  };

  systemd.network.networks."10-eth0".address = [
    "10.10.10.5/24"
    "2a0e:8f02:f017::5/48"
  ];

  networking.firewall = {
    allowedTCPPorts = [
    ];
    allowedUDPPorts = [
    ];
    extraCommands = ''
      ${pkgs.iptables}/bin/iptables -A INPUT -p tcp --dport 3323 -s 94.142.240.36 -j ACCEPT
      ${pkgs.iptables}/bin/ip6tables -A INPUT -p tcp --dport 3323 -s 2a02:898:0:20::427:1 -j ACCEPT
      ${pkgs.iptables}/bin/iptables -A INPUT -p tcp --dport 8323 -s 94.142.240.36 -j ACCEPT
      ${pkgs.iptables}/bin/ip6tables -A INPUT -p tcp --dport 8323 -s 2a02:898:0:20::427:1 -j ACCEPT
      ${pkgs.iptables}/bin/iptables -A INPUT -p tcp --dport 3323 -s 10.10.10.1 -j ACCEPT
      ${pkgs.iptables}/bin/ip6tables -A INPUT -p tcp --dport 3323 -s 2a0e:8f02:f017::/48 -j ACCEPT
      ${pkgs.iptables}/bin/iptables -A INPUT -p tcp --dport 8323 -s 10.10.10.1 -j ACCEPT
      ${pkgs.iptables}/bin/ip6tables -A INPUT -p tcp --dport 8323 -s 2a0e:8f02:f017::/48 -j ACCEPT
    '';
  };
}
