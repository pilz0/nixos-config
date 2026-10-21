{
  inputs,
  modulesPath,
  ...
}:
{
  imports = [
    ../../profiles/vm
    inputs.anodyne-flake.nixosModules.default
  ];

  pilz = {
    services.pve-container.network = {
      enable = true;
      address = [
        "10.10.10.19/24"
        "2a0e:8f02:f017::29/64"
      ];
    };
    deployment = {
      targetHost = "anodyne-nix.as214958.net";
      tags = [
        "infra"
      ];
    };
  };

  networking.firewall.allowedTCPPorts = [
    22
    80
    443
  ];

  networking = {
    hostName = "anodyne";
  };

  anodyne-wiki = {
    enable = true;
    api.enable = true;
    chrp.enable = true;
    pkgs.enable = true;
    caddy = {
      enable = true;
      domain = "anodyne-nix.as214958.net";
      contactEmail = "acme@pilz.foo";
    };
  };
  system.stateVersion = "23.11";
}
