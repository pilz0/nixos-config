{
  config,
  ...
}:

{

  age.secrets."harmonia-signing-key".file = ../../../secrets/harmonia.age;

  services.harmonia-dev = {
    enable = true;
    signKeyPaths = [ config.age.secrets."harmonia-signing-key".path ];
  };

  systemd.services.harmonia-dev.serviceConfig.Nice = "-15";

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    virtualHosts."cache.as214958.net" = {
      enableACME = true;
      forceSSL = true;
      locations."/".extraConfig = ''
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_redirect http:// https://;
        proxy_http_version 1.1;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
      '';
    };
  };

  systemd.services.nginx.serviceConfig.SupplementaryGroups = [ "harmonia" ];
}
