{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.pilz.services.knot-dns = {
    enable = lib.mkEnableOption "";
  };
  config = lib.mkIf config.pilz.services.knot-dns.enable {

  environment.etc = {
    "dns-zones" = {
      source = ./zones;
      user = "knot";
      group = "knot";
    };
  };

  services.knot = {
    enable = true;
    settings = {
      server.listen = [
        "0.0.0.0"
        "::"
      ];
      template.default = {
        file = "%s.zone";
        storage = "/etc/dns-zones";
      };
      zone = {
        "7.1.0.f.2.0.f.8.e.0.a.2.ip6.arpa" = { };
        "pilz.foo" = { };
        "ketamin.trade" = { };
        "freifick.net" = { };
      };
    };
    keyFiles = [
      config.age.secrets."tsig_ns".path
    ];
  };

  age.secrets."tsig_ns" = {
    file = ../../../secrets/tsig_ns.age;
    mode = "0400";
    owner = "knot";
    group = "knot";
  };
  };
}
