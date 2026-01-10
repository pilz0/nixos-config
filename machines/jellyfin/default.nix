{
  pkgs,
  ...
}:
{
  imports = [
    ../../modules/container
    ../../modules/container/network.nix
    ../../modules/services/nixarr
    ../../modules/nixos-builder-client
  ];

  pilz = {
    deployment.targetHost = "jellyfin.ams1.as214958.net";
    lxc.enable = true;
    lxc.ctID = "102";
  };

  networking = {
    hostName = "jellyfin";
    hostId = "4e663121";
  };

  systemd.network.networks."10-eth0".address = [
    "10.10.10.2/24"
    "2a0e:8f02:f017::4/48"
  ];

  networking.firewall = {
    allowedTCPPorts = [
    ];
    allowedUDPPorts = [
    ];
    extraCommands = ''
      ${pkgs.iptables}/bin/iptables -A INPUT -p tcp --dport 8096 -s 94.142.241.152 -j ACCEPT
      ${pkgs.iptables}/bin/ip6tables -A INPUT -p tcp --dport 8096 -s 2a0e:8f02:f017::2 -j ACCEPT
    '';
  };
}
