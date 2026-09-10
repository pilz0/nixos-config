{
  inputs,
  lib,
  config,
  ...
}:
{
  imports = [
    inputs.harmonia.nixosModules.harmonia
  ];
  options.pilz.services.binary-cache.enable = lib.mkEnableOption "";
  config = lib.mkIf config.pilz.services.binary-cache.enable {

    age.secrets."harmonia-signing-key".file = ../../../secrets/harmonia.age;

    services.harmonia-dev.cache = {
      enable = true;
      signKeyPaths = [ config.age.secrets."harmonia-signing-key".path ];
    };

    systemd.services = {
      harmonia-dev.serviceConfig.Nice = "-15";
      nginx.serviceConfig.SupplementaryGroups = [ "harmonia" ];
    };
  };
}
