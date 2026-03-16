{
  pkgs,
  config,
  lib,
  ...
}:
let
  # flow exporter is currently broken upstream with newer kafka versions (https://github.com/neptune-networks/flow-exporter/pull/21#issuecomment-3272158539)
  flow-exporter-custom = pkgs.callPackage ../../../pkgs/flow-exporter.nix { };
  cfg = config.pilz.services.netflow-exporter;
in
{
  options.pilz.services.netflow-exporter = {
    enable = lib.mkEnableOption "enable netflow exporter configuration";
    kafka = {
      clusterId = lib.mkOption {
        type = lib.types.str;
        default = "1312xxxxxxxxxxxxxxacab";
      };
      outsidePort = {
        type = lib.types.int;
        default = 9092;
      };
      controllerPort = {
        type = lib.types.int;
        default = 9093;
      };
      insidePort = {
        type = lib.types.int;
        default = 19092;
      };
      domain = {
        type = lib.types.int;
        default = "";
      };
    };
    exporter = {
      asn = {
        type = lib.types.int;
        default = 214958;
      };
      kafkaPort = {
        type = lib.types.int;
        default = 9092;
      };
      kafkaTopic = {
        type = lib.types.str;
        default = "pmacctd.acct";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    # https://discourse.nixos.org/t/how-to-setup-kafka-server-on-nixos/45055
    systemd.services.apache-kafka.unitConfig.StateDirectory = "apache-kafka";
    services.apache-kafka = {
      enable = true;
      clusterId = cfg.kafka.clusterId;
      formatLogDirs = true;
      settings = {
        listeners = [
          "INSIDE://:${toString cfg.kakfa.insidePort}"
          "OUTSIDE://:${toString cfg.kakfa.outsidePort}"
          "CONTROLLER://:${toString cfg.kakfa.controllerPort}"
        ];

        "delete.topic.enable" = true;
        "log.retention.bytes" = 1000000000;
        "auto.create.topics.enable" = true;
        "advertised.listeners" = [
          "INSIDE://:${toString cfg.kakfa.insidePort}"
          "OUTSIDE://${cfg.kafka.domain}:${toString cfg.kakfa.outsidePort}"
        ];
        "listener.security.protocol.map" = [
          "INSIDE:PLAINTEXT"
          "OUTSIDE:PLAINTEXT"
          "CONTROLLER:PLAINTEXT"
        ];
        "inter.broker.listener.name" = "INSIDE";
        "controller.quorum.voters" = [
          "1@127.0.0.1:${toString cfg.kakfa.controllerPort}"
        ];
        "controller.listener.names" = [ "CONTROLLER" ];
        "log.dirs" = [ "/tmp/apache-kafka" ];
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
        RuntimeMaxSec = "24h";
        ExecStart = "${flow-exporter-custom}/bin/flow-exporter --brokers=localhost:${toString cfg.exporter.kafkaPort} --topic=${cfg.exporter.kafkaTopic} --asn=${toString cfg.exporter.asn}";
        Restart = "on-failure";
      };
    };
  };
}
