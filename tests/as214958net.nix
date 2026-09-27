{
  name = "as214958net-test";
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
        pilz.services.as214958Net = {
          enable = true;
          domain = "server";
        };
        services.nginx.virtualHosts."server" = {
          enableACME = lib.mkForce false;
          forceSSL = lib.mkForce false;
        };
        networking.firewall = {
          allowedTCPPorts = [
            80
            443
          ];
        };
      };
  };
  testScript =
    { nodes, ... }:
    ''
      server.wait_for_unit("default.target")
      client.wait_for_unit("default.target")
      client.succeed("curl http://server/ | grep -o \"Brücher-Herpel\"")
    '';
}
