{
  name = "bird-lg-frontend";
  nodes.machine =
    { pkgs, ... }:
    {
      pilz.services.birdLg.frontend.enable = true;
      environment.systemPackages = [ pkgs.curl ];
    };

  testScript = ''
    machine.wait_for_unit("bird-lg-frontend.service")
    machine.wait_for_open_port(15000, "::1")

    with subtest("frontend serves the branded index"):
        out = machine.succeed("curl -fsSL 'http://[::1]:15000/'")
        assert "as214958" in out, out

    with subtest("both servers are listed"):
        for srv in ["ams1", "dn42"]:
            assert srv in out, out

    with subtest("frontend only listens on loopback"):
        machine.fail("curl -fsS --max-time 5 http://$(hostname -I | cut -d' ' -f1):15000/")
  '';
}
