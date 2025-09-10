{
  lib,
  pkgs,
  ...
}:
let

  script = pkgs.writeShellScriptBin "update-roa" ''
    mkdir -p /etc/bird/
    ${pkgs.curl}/bin/curl -sfSLR {-o,-z}/etc/bird/roa_dn42_v6.conf https://dn42.burble.com/roa/dn42_roa_bird2_6.conf
    ${pkgs.curl}/bin/curl -sfSLR {-o,-z}/etc/bird/roa_dn42.conf https://dn42.burble.com/roa/dn42_roa_bird2_4.conf
    ${pkgs.bird2}/bin/birdc c 
    ${pkgs.bird2}/bin/birdc reload in all
  '';
in
{
  imports = [
    ./kioubit_de2.nix
    ./zebreusDN42.nix
    ./lare_dn42.nix
    ./haaien.nix
    ./iedon.nix
    ./april_dn42.nix
    ./ernst_is_dn42.nix
    #    ./e3e.nix
    ./rhea-dn42.nix
    #    ./katja-dn42.nix
    ./nojus-dn42.nix
    ./ffda-DN42_R1.nix
    ./ffda-DN42_R2.nix
    ./prefixlabs.nix
    ./bird_templates.nix
    ./filters.nix
    ./rpki.nix
    ./NOT_MNT.nix
    ./maraun_dn42.nix
  ];
  age.secrets.wg = {
    file = ../../secrets/wg.age;
    owner = "systemd-network";
    group = "systemd-network";
  };

  systemd = {
    services = {
      dn42-roa = {
        after = [ "network.target" ];
        description = "DN42 ROA Updated";
        unitConfig = {
          Type = "one-shot";
        };
        serviceConfig = {
          ExecStart = "${script}/bin/update-roa";
        };
      };
    };

    timers.dn42-roa = {
      description = "Trigger a ROA table update";

      timerConfig = {
        OnBootSec = "5m";
        OnUnitInactiveSec = "1h";
        Unit = "dn42-roa.service";
      };

      wantedBy = [ "timers.target" ];
      before = [ "bird.service" ];
    };
    network = {
      wait-online.enable = false;
      wait-online.anyInterface = false;
      enable = true;
      config.networkConfig = {
        IPv4Forwarding = true;
        IPv6Forwarding = true;
      };
      netdevs = {
        "50-cybertrash" = {
          enable = true;
          netdevConfig = {
            Kind = "dummy";
            Name = "cybertrash";
          };
        };
      };
      networks.cybertrash = {
        matchConfig.Name = "cybertrash";
        address = [
          "fd49:d69f:6::1337/112"
          "172.22.179.129/32"
        ];
      };
    };
  };

  services.bird-lg = {
    proxy = {
      enable = true;
      listenAddress = "172.22.179.129:18000";
      allowedIPs = [ "172.0.0.0/8" ];
    };
    frontend = {
      domain = "lg.ketamin.trade";
      enable = true;
      servers = [ "serva" ];
      protocolFilter = [
        "bgp"
        "static"
      ];
      listenAddress = "[::1]:15000";
      proxyPort = 18000;
      navbar = {
        brand = "cybertrash";
      };
    };
  };

  services.nginx = {
    virtualHosts."lg.pilz.foo" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://localhost:15000";
      };
    };
  };

  services.bird = {
    enable = true;
    package = pkgs.bird2;
    autoReload = true;
    preCheckConfig = lib.mkOrder 2 ''
      # Remove roa files for checking, because they are only available at runtime
      sed -i 's|include "/etc/bird/roa_dn42.conf";||' bird.conf
      sed -i 's|include "/etc/bird/roa_dn42_v6.conf";||' bird.conf

      cat -n bird.conf
    '';
    config = lib.mkOrder 1 ''
      define OWNAS = 4242420663;
      define OWNNET = 172.22.179.128/27;
      define OWNNETv6 = fd49:d69f:6::/48;
      define OWNNETSET = [ 172.22.179.128/27 ];
      define OWNNETSETv6 = [ fd49:d69f:6::/48 ];
      define OWNIP = 172.22.179.129;
      define OWNIPv6 = fd49:d69f:6::1337;

      ################################################
      #                 Header end                   #
      ################################################

      router id OWNIP;

      protocol device {
          scan time 10;
      }

      protocol kernel {
          scan time 20;

          ipv6 {
              import none;
              export filter {
                  if source = RTS_STATIC then reject;
                  krt_prefsrc = OWNIPv6;
                  accept;
              };
          };
      };

      protocol kernel {
          scan time 20;

          ipv4 {
              import none;
              export filter {
                  if source = RTS_STATIC then reject;
                  krt_prefsrc = OWNIP;
                  accept;
              };
          };
      }

      protocol static {
          route OWNNET reject;

          ipv4 {
              import all;
              export none;
          };
      }

      protocol static {
          route OWNNETv6 reject;

          ipv6 {
              import all;
              export none;
          };
      }
    '';
  };
}
