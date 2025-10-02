{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./bgp-peerings.nix
    ../../../modules/rpki
    ../../../modules/bgp-filters
    ../../../modules/bird-templates
    ../../../modules/bird-default
    ../../../modules/rpki-dn42
  ];

  services.prometheus.exporters.bird = {
    openFirewall = true;
  };

  networking.firewall = {
    interfaces = {
      "ens19".allowedTCPPorts = [ 179 ];
    };
    extraCommands = ''
      ${pkgs.iptables}/bin/ip6tables -A INPUT -p tcp --dport 179 -i ens18 -s 2a0c:b640:10::2:ffff -j ACCEPT
    '';
  };

  services.bird = {
    enable = true;
    package = pkgs.bird2;
    autoReload = true;
    config = lib.mkOrder 3 ''
      router id 225.3.77.150;

      protocol static announce_ipv6 {
        ipv6;
        route 2a0e:8f02:f017::/48 unreachable;
      }
    '';
  };
}
