{
  pkgs,
  inputs,
  config,
  pkgs-unstable,
  ...
}:
{
  imports = [
    ../../profiles/container
    ../../modules/services/nixarr
    inputs.fedi-bot.nixosModules.default
  ];

  age.secrets.fediToken = {
    file = ../../secrets/fedi-bot-fediToken.age;
  };
  age.secrets.hfToken = {
    file = ../../secrets/fedi-bot-hfToken.age;
  };

  services.fedi-bot-inference = {
    #enable = true;
    threads = 64;
    contextSize = 4096;
    model.localPath = "/var/lib/fedi-models/fedi-persona-q6_k.gguf";
    #package = pkgs-unstable.llama-cpp;
  };

  services.fedi-bot = {
    #enable = true;
    inferenceUrl = "http://127.0.0.1:8080/v1";
    instanceUrl = "https://girldick.gay";
    accessTokenFile = config.age.secrets.fediToken.path;
    post.perDay = 100;
  };

  pilz = {
    services.pve-container.network = {
      enable = true;
      address = [
        "10.10.10.17/24"
        "2a0e:8f02:f017::27/64"
      ];
    };
    deployment = {
      targetHost = "2a0e:8f02:f017::27";
      tags = [ "infra" ];
    };
    lxc = {
      enable = true;
      ctID = "125";
    };
  };
  users.users = {
    snakii = {
      extraGroups = [
        "wheel"
      ];
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA/+iN407+HsfHbbC3tfdA8Yf4TZ08qXQMb4tb/SDAs+"
      ];
    };
  };
  networking = {
    hostName = "fedi-bot";
    hostId = "4d6d3223";
  };

  networking.firewall = {
    allowedTCPPorts = [
    ];
    allowedUDPPorts = [
    ];
    extraCommands = ''
    '';
  };
}
