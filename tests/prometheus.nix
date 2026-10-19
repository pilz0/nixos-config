{
  name = "prometheus";
  nodes.machine =
    { pkgs, ... }:
    {
      pilz.monitoring = {
        prometheus.enable = true;
        blackbox-anodyne.enable = true;
      };
      environment.systemPackages = [ pkgs.curl ];
    };

  testScript = ''
    machine.wait_for_unit("prometheus.service")
    machine.wait_for_unit("prometheus-blackbox-exporter.service")
    machine.wait_for_open_port(1312)
    machine.wait_for_open_port(9115)

    with subtest("prometheus is ready"):
        machine.wait_until_succeeds("curl -fsS http://localhost:1312/-/ready")

    with subtest("all scrape jobs are loaded"):
        for job in ["nodes", "tor", "blackbox", "ping-probe"]:
            machine.wait_until_succeeds(
                f"curl -fsS http://localhost:1312/api/v1/targets | grep -q '\"scrapePool\":\"{job}\"'"
            )

    with subtest("blackbox icmp probe works"):
        machine.succeed(
            "curl -fsS 'http://localhost:9115/probe?module=icmp&target=127.0.0.1' | grep -q '^probe_success 1'"
        )

    with subtest("blackbox http-2xx module enforces ssl"):
        machine.succeed(
            "curl -fsS 'http://localhost:9115/probe?module=http-2xx&target=http://localhost:1312/-/ready' | grep -q '^probe_success 0'"
        )
  '';
}
