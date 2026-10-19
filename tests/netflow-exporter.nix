{
  name = "netflow-exporter";
  nodes.machine =
    { pkgs, ... }:
    {
      pilz.monitoring.netflow-exporter.enable = true;
      virtualisation.memorySize = 2048;
      environment.systemPackages = [ pkgs.curl ];
    };

  testScript = ''
    machine.wait_for_unit("apache-kafka.service")
    machine.wait_for_open_port(9092)
    machine.wait_for_open_port(19092)

    with subtest("flow-exporter connects to kafka and serves metrics"):
        machine.wait_for_unit("flow-exporter.service")
        machine.wait_for_open_port(9590, timeout=120)
        machine.succeed("curl -fsS http://localhost:9590/metrics | grep -q '^# HELP'")
  '';
}
