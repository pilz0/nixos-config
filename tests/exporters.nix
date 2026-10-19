{
  name = "exporters";
  nodes = {
    server =
      { nodes, ... }:
      {
        pilz.monitoring = {
          node-exporter = {
            enable = true;
            monitoring-servers-v4 = nodes.scraper.networking.primaryIPAddress;
          };
          systemd-exporter = {
            enable = true;
            monitoring-servers-v4 = nodes.scraper.networking.primaryIPAddress;
          };
        };
      };
    scraper =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.curl ];
      };
    stranger =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.curl ];
      };
  };

  testScript = ''
    start_all()
    server.wait_for_unit("prometheus-node-exporter.service")
    server.wait_for_unit("prometheus-systemd-exporter.service")
    server.wait_for_open_port(9100)
    server.wait_for_open_port(9558)
    scraper.wait_for_unit("multi-user.target")
    stranger.wait_for_unit("multi-user.target")

    with subtest("monitoring server can scrape both exporters"):
        scraper.succeed("curl -4 -fsS --max-time 10 http://server:9100/metrics | grep '^node_uname_info' >/dev/null")
        scraper.succeed("curl -4 -fsS --max-time 10 http://server:9558/metrics | grep '^systemd_unit_state' >/dev/null")

    with subtest("other hosts are firewalled off"):
        for port in [9100, 9558]:
            stranger.fail(f"curl -4 -fsS --max-time 5 http://server:{port}/metrics")
            stranger.fail(f"curl -6 -fsS --max-time 5 http://server:{port}/metrics")
  '';
}
