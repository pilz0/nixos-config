{
  pkgs,
  ...
}:
{
  imports = [
    ../../profiles/container
    ../../modules/services/nginx
    ../../modules/monitoring/prometheus
    ../../modules/monitoring/grafana
    ../../modules/monitoring/netflow-exporter
    ../../modules/monitoring/loki
  ];

  pilz = {
    services.grafana.enable = true;
    services.loki.enable = true;
    services.netflow-exporter.enable = true;
    services.pve-container.network = {
      enable = true;
      address = [
        "10.10.10.3/24"
        "2a0e:8f02:f017::3/64"
      ];
    };
    deployment = {
      targetHost = "grafana.ams1.as214958.net";
      tags = [ "infra" ];
    };
    lxc = {
      enable = true;
      ctID = "101";
    };
  };

  age.secrets = {
    smtp = {
      file = ../../secrets/smtp.age;
      owner = "grafana";
      group = "grafana";
    };
    grafana = {
      file = ../../secrets/grafana.age;
      owner = "grafana";
      group = "grafana";
    };
  };

  networking = {
    hostName = "grafana";
    hostId = "4066b432";
  };

  networking.firewall = {
    allowedTCPPorts = [
    ];
    allowedUDPPorts = [
    ];
    extraCommands = ''
      ${pkgs.iptables}/bin/ip6tables -A INPUT -p tcp --dport 9092 -s 2a0e:8f02:f017::1 -j ACCEPT
      ${pkgs.iptables}/bin/ip6tables -A INPUT -p tcp --dport 9092 -s 2a02:898:0:20::427:1 -j ACCEPT
      ${pkgs.iptables}/bin/iptables -A INPUT -p tcp --dport 3001 -s 94.142.241.152 -j ACCEPT
      ${pkgs.iptables}/bin/ip6tables -A INPUT -p tcp --dport 3001 -s 2a0e:8f02:f017::2 -j ACCEPT
      ${pkgs.iptables}/bin/ip6tables -A INPUT -p tcp --dport 3100 -s 2a0e:8f02:f017::0/48 -j ACCEPT
      ${pkgs.iptables}/bin/ip6tables -A INPUT -p tcp --dport 3100 -s 2a02:898:0:20::427:1 -j ACCEPT
    '';
  };
}
