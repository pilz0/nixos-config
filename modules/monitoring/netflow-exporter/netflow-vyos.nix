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

  environment.etc."pmacct-netflow-vyos/nfacctd.conf".text = ''
    nfacctd_port: 9995
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
  '';
}
