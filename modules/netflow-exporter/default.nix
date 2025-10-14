{
  flow-exporter-custom,
  ...
}:
{

  # https://discourse.nixos.org/t/how-to-setup-kafka-server-on-nixos/45055
  systemd.services.apache-kafka.unitConfig.StateDirectory = "apache-kafka";
  services.apache-kafka = {
    enable = true;
    clusterId = "xxxxxxxxxxxxxxxxxxxxxx";
    formatLogDirs = true;
    settings = {
      listeners = [
        "INSIDE://:19092"
        "OUTSIDE://:9092"
        "CONTROLLER://:9093"
      ];

      "delete.topic.enable" = true;
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

  # port 9590
  systemd.services.flow-exporter = {
    enable = true;
    description = "Prometheus Flow Exporter";
    after = [
      "network.target"
      "apache-kafka.service"
    ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${flow-exporter-custom}/bin/flow-exporter --brokers=localhost:9092 --topic=pmacctd.acct --asn=214958";
      Restart = "on-failure";
    };
  };
}
