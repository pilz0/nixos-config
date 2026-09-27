{ hostPkgs, ... }:
let
  # throwaway age identity + the smtp secret encrypted to it
  ageFixture =
    hostPkgs.runCommand "flohannes-de-age-fixture" { nativeBuildInputs = [ hostPkgs.age ]; }
      ''
        mkdir $out
        age-keygen -o $out/key.txt
        echo -n test-smtp-password | age -r "$(age-keygen -y $out/key.txt)" -o $out/smtp.age
      '';
in
{
  name = "flohannes-de";
  # the module adds a nixpkgs overlay
  node.pkgsReadOnly = false;

  nodes = {
    server =
      { lib, ... }:
      {
        pilz.services.flohannes-de.enable = true;

        age.identityPaths = [ "${ageFixture}/key.txt" ];
        age.secrets.smtp-flohannes.file = lib.mkForce "${ageFixture}/smtp.age";

        services.nginx.virtualHosts."flohannes.de" = {
          enableACME = lib.mkForce false;
          forceSSL = lib.mkForce false;
        };
        networking.firewall.allowedTCPPorts = [ 80 ];
      };
    client =
      { nodes, pkgs, ... }:
      {
        networking.hosts.${nodes.server.networking.primaryIPAddress} = [ "flohannes.de" ];
        environment.systemPackages = [ pkgs.curl ];
      };
  };

  testScript = ''
    start_all()
    server.wait_for_unit("phpfpm-wordpress-flohannes.de.service")
    server.wait_for_unit("nginx.service")
    server.wait_for_open_port(80)

    with subtest("wordpress-init went through"):
        assert server.get_unit_info("wordpress-init-flohannes.de")["Result"] == "success"

    with subtest("fresh site redirects to the installer"):
        location = client.succeed("curl -sS -o /dev/null -w '%{redirect_url}' http://flohannes.de/")
        assert location.endswith("/wp-admin/install.php"), location

    with subtest("installer is served"):
        out = client.succeed("curl -fsS http://flohannes.de/wp-admin/install.php")
        assert "install.php?step=" in out, out

    with subtest("plugins and theme are installed"):
        for path in [
            "plugins/contact-form-7/readme.txt",
            "plugins/wordpress-seo/readme.txt",
            "plugins/webp-express/README.txt",
            "themes/twentysixteen/style.css",
        ]:
            client.succeed(f"curl -fsS -o /dev/null http://flohannes.de/wp-content/{path}")

    with subtest("webp-express state dir exists"):
        server.succeed("test -d /var/lib/wordpress/flohannes.de/webp-express")

    with subtest("smtp secret is decrypted and readable by wordpress"):
        pw = server.succeed("runuser -u wordpress -- cat /run/agenix/smtp-flohannes")
        assert pw == "test-smtp-password", pw
  '';
}
