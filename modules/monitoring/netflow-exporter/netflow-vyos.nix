{
  lib,
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
      ExecStart = "${pkgs.pmacct}/sbin/pmacctd -f /etc/pmacct/pmacctd.conf";
      Restart = "on-failure";
    };
  };

  environment.etc."pmacct/nfacctd.conf".text = ''
    aggregate: src_port, dst_port, src_as, dst_as, src_net, dst_net, src_mask, dst_mask, label
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

  environment.etc."pmacct/pmacctd.conf".text = ''
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
    aggregate: src_port, dst_port, src_as, dst_as, src_net, dst_net, src_mask, dst_mask, label
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
  environment.etc."pmacct/interfaces.map".text = ''
    ifindex=100  ifname=vmbr1
  '';
  environment.etc."pmacct/networks.lst".text = ''
    214958,94.142.241.152/31,2a0e:8f02:f017::/48
  '';
  environment.etc."pmacct/pretag.map".text = ''
    set_label=ams1.as214958.net
  '';
  environment.etc."pmacct/peering_agent.map".text = ''
    bgp_ip=94.142.240.36     ip=0.0.0.0/0
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
}
