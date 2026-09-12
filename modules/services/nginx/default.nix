{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.pilz.services.nginx;
in
{
  options.pilz.services.nginx = {
    enable = lib.mkEnableOption "enable pilz nginx service";
    enableMonitoring = lib.mkEnableOption "enable monitoring";
  };
  imports = [
    ./tiles.nix
  ];
  config = lib.mkIf cfg.enable {

    services.prometheus.exporters.nginx = {
      enable = cfg.enableMonitoring;
    };

    age.secrets = {
      cloudflare_cert = {
        file = ../../../secrets/cloudflare_cert.age;
        owner = "nginx";
        group = "nginx";
      };
      cloudflare_key = {
        file = ../../../secrets/cloudflare_key.age;
        owner = "nginx";
        group = "nginx";
      };
    };

    networking.firewall.extraCommands = lib.mkIf cfg.enableMonitoring ''
      ${pkgs.iptables}/bin/ip6tables -A INPUT -p tcp --dport ${toString config.services.prometheus.exporters.nginx.port} -s 2a0e:8f02:f017::3 -j ACCEPT
    '';

    services = {
      nginx = {
        statusPage = cfg.enableMonitoring;
        enable = true;
        recommendedGzipSettings = lib.mkDefault true;
        recommendedOptimisation = lib.mkDefault true;
        recommendedProxySettings = lib.mkDefault true;
        recommendedTlsSettings = lib.mkDefault true;
        commonHttpConfig =
          let
            realIpsFromList = lib.strings.concatMapStringsSep "\n" (x: "set_real_ip_from  ${x};");
            fileToList = x: lib.strings.splitString "\n" (builtins.readFile x);
            cfipv4 = fileToList (
              pkgs.fetchurl {
                url = "https://www.cloudflare.com/ips-v4";
                sha256 = "0ywy9sg7spafi3gm9q5wb59lbiq0swvf0q3iazl0maq1pj1nsb7h";
              }
            );
            cfipv6 = fileToList (
              pkgs.fetchurl {
                url = "https://www.cloudflare.com/ips-v6";
                sha256 = "1ad09hijignj6zlqvdjxv7rjj8567z357zfavv201b9vx3ikk7cy";
              }
            );
          in
          ''
            ${realIpsFromList cfipv4}
            ${realIpsFromList cfipv6}
            real_ip_header CF-Connecting-IP;
            map $scheme $hsts_header {
              https   "max-age=31536000; includeSubdomains; preload";
            }
          '';
      };
    };
  };
}
