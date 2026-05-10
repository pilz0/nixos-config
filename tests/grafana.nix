{ pkgs, ... }:
pkgs.testers.runNixOSTest {
  name = "grafana-test";
  nodes = {
    client =
      { config, pkgs, ... }:
      {
        environment.systemPackages = [
          pkgs.curl
        ];
      };
    server =
      { lib, ... }:
      {
        imports = [
          ../modules/monitoring/grafana/default.nix
        ];
        pilz.services.grafana = {
          enable = true;
          port = 3000;
          smtp = {
            password = "";
          };
          adminPassword = "admin123";
        };
        networking.firewall = {
          allowedTCPPorts = [
            3000
          ];
        };
      };
  };
  testScript =
    { nodes, ... }:
    ''
      server.wait_for_open_port(3000)
      client.wait_for_unit("default.target")
      client.succeed("curl http://server:3000/api/health | grep -o \"ok\"")
    '';
}
