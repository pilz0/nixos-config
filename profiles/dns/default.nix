{
  lib, 
  config, 
  pkgs,
  ... 
}:
{
  pilz.deployment.tags = [ "dns" ];
  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
  services.resolved = {
    enable = false;
    settings.Resolve.cache = false;
    settings.Resolve.DNSStubListener = false;
  };

  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  imports = [
    ../../modules/services/knot-dns
  ];
}
