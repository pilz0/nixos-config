{ ... }:
{
  services.prometheus = {
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9100;
      };
      bird = {
        enable = true;
      };
      wireguard = {
        enable = true;
        withRemoteIp = true;
      };
      smokeping = {
        enable = true;
        hosts = [
          "google.com"
          "ip6.clerie.de"
        ];
      };
    };
  };
}
