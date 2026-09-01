{
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    (pkgs.pmacct.override {
      withKafka = true;
      withJansson = true;
      withPgSQL = true;
      withSQLite = true;
    })
  ];

  systemd.services.pmacctd = {
    enable = true;
    description = "pmacctd flow collector (pcap) for Prometheus exporter";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.pmacct}/sbin/pmacctd -f /etc/pmacct-netflow-vyos/nfacctd.conf";
      Restart = "on-failure";
    };
  };

  systemd.services.flow-exporter-vyos = {
    enable = true;
    description = "Prometheus Flow Exporter";
    after = [
      "network.target"
      "apache-kafka.service"
    ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      RuntimeMaxSec = "24h";
      ExecStart = "${flow-exporter-custom}/bin/flow-exporter --brokers=kafka.as214958.net:9092--topic=pmacctdAS203819.acct --asn=203819";
      Restart = "on-failure";
    };
  };

  environment.etc."pmacct-netflow-vyos/nfacctd.conf".text = ''
    nfacctd_port: 9995
    nfacctd_ip: 0.0.0.0
    !
    aggregate: src_host, dst_host, src_port, dst_port, tcpflags, proto, label
    !
    plugins: kafka
    kafka_output: json
    kafka_json_newline: true
    kafka_broker_host: kafka.as214958.net
    kafka_broker_port: 9092
    kafka_refresh_time: 5
    kafka_history: 5m
    kafka_history_roundoff: m
    kafka_topic: pmacctdAS203819.acct
    !
    bgp_daemon: true
    bgp_daemon_ip: 
    bgp_daemon_port: 179
    bgp_daemon_max_peers: 10
    bgp_agent_map: /etc/pmacct-netflow-vyos/bgp_agent.map
  '';

  environment.etc."pmacct-netflow-vyos/bgp_agent.map".text = ''
    bgp_ip=  ip=0.0.0.0/0
  '';
}
