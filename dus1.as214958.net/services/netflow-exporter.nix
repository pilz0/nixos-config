{
  pkgs,
  lib,
  config,
  ...
}:
{
  # https://brooks.sh/2019/11/17/network-flow-analysis-with-prometheus/
  environment.systemPackages = with pkgs; [
    pmacct
  ];
  systemd.services.pmacctd = {
    enable = true;
    description = "pmacctd Netflow probe";
    unitConfig = {
      Type = "simple";
    };
    serviceConfig = {
      execStart = "${pkgs.pmacctd}/sbin/pmacctd -f /etc/pmacct/pmacctd.conf";
    };
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
  };

  systemd = {
    network = {
      netdevs = {
        "60-lo2" = {
          enable = true;
          netdevConfig = {
            Kind = "dummy";
            Name = "lo2";
          };
        };
      };
      networks.dummyinter = {
        matchConfig.Name = "lo2";
        address = [
          "127.0.0.2/32"
        ];
        networkConfig = {
          ConfigureWithoutCarrier = true;
        };
      };
    };
  };

  environment.etc."pmacct/pmacctd.conf".text = ''
    daemonize: false
    pcap_interfaces_map: /etc/pmacct/interfaces.map
    pre_tag_map: /etc/pmacct/pretag.map
    pmacctd_as: longest
    pmacctd_net: longest
    networks_file: /etc/pmacct/networks.lst
    networks_file_no_lpm: true
    sampling_rate: 1
    aggregate: src_host, dst_host, src_port, dst_port, src_as, dst_as, label, proto
    !
    bgp_daemon: true
    bgp_daemon_ip: 127.0.0.2
    bgp_daemon_port: 180
    bgp_daemon_max_peers: 10
    bgp_agent_map: /etc/pmacct/peering_agent.map
    !
    plugins: kafka
    kafka_output: json
    kafka_broker_host: kafka.as214958.net
    kafka_refresh_time: 5
    kafka_history: 5m
    kafka_history_roundoff: m
  '';
  environment.etc."pmacct/interfaces.map".text = ''
    ifindex=100  ifname=ens18
    ifindex=200  ifname=ens19
  '';
  environment.etc."pmacct/networks.lst".text = ''
    214958,2a0e:8f02:f017::/48
  '';
  environment.etc."pmacct/pretag.map".text = ''
    set_label=dus1.as214958.net
  '';
  environment.etc."pmacct/peering_agent.map".text = ''
    bgp_ip=225.3.77.150     ip=0.0.0.0/0
  '';
  services.bird = {
    config = lib.mkOrder 5 ''
      protocol bgp pmacctd {
        description "pmacctd";
        local 127.0.0.1 as 214958;
        neighbor 127.0.0.2 port 180 as 214958;
        rr client;
        hold time 90;
        keepalive time 30;
        graceful restart;

        ipv4 {
          next hop self;
          import filter { 
            reject;
          };
          export filter { 
            accept;
          };
        };

        ipv6 {
          next hop address 127.0.0.1;
          import filter { 
            reject;
            };
          export filter { 
            accept; 
          };
        };
      }
    '';
  };

  # https://discourse.nixos.org/t/how-to-setup-kafka-server-on-nixos/45055
  services.apache-kafka = {
    enable = true;
    # Replace with a randomly generated uuid. You can get one by running:
    # kafka-storage.sh random-uuid
    clusterId = "xxxxxxxxxxxxxxxxxxxxxx";
    formatLogDirs = true;
    settings = {
      listeners = [
        "INSIDE://:19092"
        "OUTSIDE://:9092"
      ];
      "auto.create.topics.enable" = true;
      "advertised.listeners" = [
        "INSIDE://:19092"
        "OUTSIDE://kafka.as214958.net:9092"
      ];
      "listener.security.protocol.map" = [
        "INSIDE:PLAINTEXT"
        "OUTSIDE:PLAINTEXT"
      ];
      "controller.quorum.voters" = [
        "1@127.0.0.1:9093"
      ];
      "controller.listener.names" = [ "CONTROLLER" ];

      "node.id" = 1;
      "process.roles" = [
        "broker"
        "controller"
      ];

      # I prefer to use this directory, because /tmp may be erased
      "log.dirs" = [ "/var/lib/apache-kafka" ];
      "offsets.topic.replication.factor" = 1;
      "transaction.state.log.replication.factor" = 1;
      "transaction.state.log.min.isr" = 1;
    };
  };

  # Set this so that systemd automatically create /var/lib/apache-kafka
  # with the right permissions
  systemd.services.apache-kafka.unitConfig.StateDirectory = "apache-kafka";

  services.prometheus.exporters.flow = {
    enable = true;
    brokers = [ "kafka.as214958.net:19092" ];
    asn = 214958;
    topic = "pmacct.acct:3:1";
  };
  networking.firewall = {
    allowedTCPPorts = [
      config.services.prometheus.exporters.flow.port
    ];
  };
}
