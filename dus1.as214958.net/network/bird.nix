{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./bgp-filters.nix
    ./bgp-peerings.nix
    ./rpki.nix
    ./bird_templates.nix
    #   ./routinator.nix # disabled due to resource usage
  ];

  services.prometheus = {
    exporters = {
      bird = {
        openFirewall = true;
        enable = true;
      };
    };
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
      log syslog all;

      router id 225.3.77.150;

      protocol device {
      scan time 60;
      }

      # Inject received BGP routes into the Linux kernel
      protocol kernel krnv4 {
      scan time 60;
      ipv4 {
        import none;
        export all;
      };
      }

      protocol kernel krnv6 {
      scan time 60;
      ipv6 {
        import none;
        export all;
      };
      }

      protocol static announce_ipv6 {
      ipv6;
      route 2a0e:8f02:f017::/48 unreachable;
      }
    '';
  };
}
