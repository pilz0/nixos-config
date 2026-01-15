{
  pkgs,
  config,
  ...
}:
{
  systemd.tmpfiles.rules = [
    "d /var/www/cache/testfile 0755 nginx nginx -"
    "d /var/www/cache/testfile 0755 nginx nginx -"
  ];

  environment.systemPackages = with pkgs; [
    wget
  ];

  systemd.services."testfile-setup" = {
    serviceConfig.Type = "oneshot";
    wants = [ "network-online.target" ];
    wantedBy = [ "multiuser.target" ];
    serviceConfig = {
      TimeoutSec = 1000;
    };
    script = ''
      if [ ! -d /var/www/testfile/files ]; then
        mkdir -p /var/www/testfile/files
      fi
      if [ ! -d /var/www/testfile/files/100MB.bin ]; then
        
        ${pkgs.wget}/bin/wget -O /var/www/testfile/files/100MB.bin https://fsn1-speed.hetzner.com/100MB.bin
      fi
      chmod -R 777 /var/www/testfile
      if [ ! -d /var/www/testfile/files/1GB.bin ]; then
        ${pkgs.wget}/bin/wget -O /var/www/testfile/files/1GB.bin https://fsn1-speed.hetzner.com/1GB.bin
      fi
      chmod -R 777 /var/www/testfile
    '';
  };
  environment.etc = {
    "testfile-site" = {
      source = ./webroot;
      group = config.services.nginx.group;
      user = config.services.nginx.user;
    };
  };

  services = {
    nginx = {
      virtualHosts = {
        "testfile.as214958.net" = {
          enableACME = true;
          forceSSL = true;
          locations."/files" = {
            root = "/var/www/testfile/";
          };
          locations."/" = {
            root = "/etc/testfile-site";
          };
        };
      };
    };
  };
}
