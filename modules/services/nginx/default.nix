{
  pkgs,
  lib,
  ...
}:
{
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

  services = {
    nginx = {
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
        '';
    };
  };
}
