{
  inputs,
  lib,
  config,
  options,
  ...
}:
{
  options.pilz.services.binary-cache.enable = lib.mkEnableOption "";
  config =
    if options ? services && options.services ? harmonia && options.services.harmonia ? cache then
      lib.mkIf config.pilz.services.binary-cache.enable {
        age.secrets."harmonia-signing-key".file = ../../../secrets/harmonia.age;

        services.harmonia.cache = {
          enable = true;
          signKeyPaths = [ config.age.secrets."harmonia-signing-key".path ];
        };

        systemd.services = {
          harmonia.serviceConfig.Nice = "-15";
          nginx.serviceConfig.SupplementaryGroups = [ "harmonia" ];
        };
      }
    else
      { };
}
