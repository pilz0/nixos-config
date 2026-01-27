{
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.nixarr.nixosModules.default
  ];
  age.secrets.nixarr-wg = {
    file = ../../../secrets/nixarr-wg.age;
    owner = "nixarr";
    group = "nixarr";
  };

  nixarr = {
    enable = true;
    mediaDir = "/srv/";
    stateDir = "/srv/media/.state/nixarr";

    vpn = {
      enable = true;
      wgConf = config.age.secrets.nixarr-wg.path;
    };

    transmission = {
      enable = true;
      vpn.enable = true;
      peerPort = 63993;
      extraSettings = {
      };
    };
  };

  services = {
    jellyfin = {
      enable = true;
    };
    jellyseerr = {
      enable = true;
    };
  };
}
