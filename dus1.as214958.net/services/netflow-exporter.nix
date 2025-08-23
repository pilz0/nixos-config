{
  lib,
  pmacct-custom,
  flow-exporter-custom,
  ...
}:
{

  # pmacctd without Kafka: keep everything in memory for exporter to query
  systemd.services.pmacctd = {
    enable = true;
    description = "pmacctd flow collector (pcap) for Prometheus exporter";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pmacct-custom}/sbin/pmacctd -f /etc/pmacct/pmacctd.conf";
      Restart = "on-failure";
    };
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
      networks."lo2" = {
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
    # debug: true
    daemonize: false
    pcap_interfaces_map: /etc/pmacct/interfaces.map
    pre_tag_map: /etc/pmacct/pretag.map
    pmacctd_as: longest
    pmacctd_net: longest
    networks_file: /etc/pmacct/networks.lst
    networks_file_no_lpm: true
    sampling_rate: 1
    !
    bgp_daemon: true
    bgp_daemon_ip: 127.0.0.2
    bgp_daemon_port: 180
    bgp_daemon_max_peers: 10
    bgp_agent_map: /etc/pmacct/peering_agent.map
    !
    aggregate: src_host, dst_host, src_port, dst_port, src_as, dst_as, label, proto
    !
    plugins: kafka
    kafka_output: json
    kafka_broker_host: kafka.as214958.net
    kafka_broker_port: 9092
    kafka_refresh_time: 5
    kafka_history: 5m
    kafka_history_roundoff: m
    kafka_topic: pmacct.acct
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
        "CONTROLLER://:9093"
      ];
      "auto.create.topics.enable" = true;
      "advertised.listeners" = [
        "INSIDE://:19092"
        "OUTSIDE://kafka.as214958.net:9092"
      ];
      "listener.security.protocol.map" = [
        "INSIDE:PLAINTEXT"
        "OUTSIDE:PLAINTEXT"
        "CONTROLLER:PLAINTEXT"
      ];
      "inter.broker.listener.name" = "INSIDE";
      "controller.quorum.voters" = [
        "1@127.0.0.1:9093"
      ];
      "controller.listener.names" = [ "CONTROLLER" ];
      "log.dirs" = [ "/var/lib/apache-kafka" ];

      "node.id" = 1;
      "process.roles" = [
        "broker"
        "controller"
      ];
    };
  };

  systemd.services.apache-kafka.unitConfig.StateDirectory = "apache-kafka";

  systemd.services.flow-exporter = {
    enable = true;
    description = "Prometheus Flow Exporter";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${flow-exporter-custom}/bin/flow-exporter --brokers=kafka.as214958.net:9092 --topic=pmacct.acct --asn=214958";
      Restart = "on-failure";
    };
  };
  networking.firewall = {
    allowedTCPPorts = [
      9590 # flow-exporter
    ];
  };
}
