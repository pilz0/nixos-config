{
  name = "loki";
  nodes.machine =
    { pkgs, ... }:
    {
      pilz.monitoring.loki.enable = true;
      environment.systemPackages = [ pkgs.curl ];
    };

  testScript = ''
    import json

    machine.wait_for_unit("loki.service")
    machine.wait_for_open_port(3100)

    with subtest("loki becomes ready"):
        machine.wait_until_succeeds("curl -fsS http://localhost:3100/ready | grep -q ready", timeout=180)

    with subtest("logs can be pushed and queried back"):
        ts = machine.succeed("date +%s%N").strip()
        payload = json.dumps({
            "streams": [{"stream": {"job": "nixos-test"}, "values": [[ts, "hello-from-nixos-test"]]}]
        })
        machine.wait_until_succeeds(
            "curl -fsS -H 'Content-Type: application/json' -X POST "
            f"--data-raw '{payload}' http://localhost:3100/loki/api/v1/push"
        )
        machine.wait_until_succeeds(
            "curl -fsSG http://localhost:3100/loki/api/v1/query_range "
            "--data-urlencode 'query={job=\"nixos-test\"}' | grep -q hello-from-nixos-test",
            timeout=120,
        )
  '';
}
