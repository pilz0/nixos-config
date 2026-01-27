{
  inputs,
  config,
  ...
}:

{

  imports = [
    inputs.harmonia.nixosModules.harmonia
  ];

  age.secrets."harmonia-signing-key".file = ../../../secrets/harmonia.age;

  services.harmonia-dev = {
    enable = true;
    signKeyPaths = [ config.age.secrets."harmonia-signing-key".path ];
  };

  systemd.services.harmonia-dev.serviceConfig.Nice = "-15";

  systemd.services.nginx.serviceConfig.SupplementaryGroups = [ "harmonia" ];
}
