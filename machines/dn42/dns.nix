{
  imports = [
    ../../profiles/dns
  ];

  services.knot = {
    settings = {
      remote = {
        remote_slave_ns = {
          address = [
            "89.168.97.129"
          ];
          key = "tsig_ns";
        };
      };
      log.syslog.any = "info";
      acl = {
        "acl_slave_ns" = {
          key = "tsig_ns";
          address = [
            "89.168.97.129"
          ];
          action = "transfer";
        };
      };
      template.default = {
        notify = [ "remote_slave_ns" ];
        acl = [ "acl_slave_ns" ];
        zonefile-sync = "-1";
        zonefile-load = "difference";
        journal-content = "changes";
      };
      template.local = {
        zonefile-sync = "-1";
        zonefile-load = "difference";
        journal-content = "changes";
      };
    };
  };
}
