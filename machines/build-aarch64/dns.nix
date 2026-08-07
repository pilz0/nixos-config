{
  imports = [
    ../../profiles/dns
  ];
  services.knot = {
    settings = {
      remote = {
        master_ns1 = {
          address = [
            "94.142.241.1"
            "2a0e:8f02:f017::6"
          ];
          key = "tsig_ns";
        };
      };
      acl = {
        "acl_ns1" = {
          address = [
            "94.142.241.1"
            "2a0e:8f02:f017::6"
          ];
          action = "notify";
          key = "tsig_ns";
        };
      };
      template.default = {
        master = [ "master_ns1" ];
        acl = [ "acl_ns1" ];
      };
    };
  };
}
