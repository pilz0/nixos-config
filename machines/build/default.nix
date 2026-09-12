{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ../../profiles/container
    ../../profiles/builder
  ];

  age.secrets.github-runner = {
    file = ../../secrets/github-runner.age;
    owner = "github-runner";
    group = "github-runner";
  };

  pilz = {
    services.pve-container.network = {
      enable = true;
      address = [
        "10.10.10.8/24"
        "2a0e:8f02:f017::8/64"
      ];
    };
    deployment = {
      targetHost = "build.ams1.as214958.net";
      tags = [
        "infra"
        "builder"
      ];
    };
    lxc = {
      enable = true;
      ctID = "106";
    };

    services.github-runner = {
      runners = {
        "nixos-config" = {
          user = "github-runner";
          enable = true;
          url = "https://github.com/pilz0/nixos-config";
          name = "ams1-runner";
          replace = true;
          tokenFile = config.age.secrets.github-runner.path;
        };
        "better-journal" = {
          extraPackages = with pkgs; [
            curl
            wget
            cacert
            jetbrains.jdk
          ];
          user = "github-runner";
          enable = true;
          url = "https://github.com/pilz0/better-journal";
          name = "ams1-runner";
          replace = true;
          tokenFile = config.age.secrets.github-runner.path;
        };
        "ams1" = {
          user = "github-runner";
          enable = true;
          url = "https://github.com/as214958";
          name = "ams1-runner";
          replace = true;
          tokenFile = config.age.secrets.github-runner.path;
        };
      };
    };
  };

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

  nix.settings = {
    max-jobs = 10;
    cores = 36;
  };

  networking = {
    hostName = "build";
    hostId = "12163e34";
  };

  networking.firewall = {
    allowedTCPPorts = [
      80
      443
    ];
    allowedUDPPorts = [
    ];
  };
}
