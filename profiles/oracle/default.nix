{
  inputs,
  modulesPath,
  config,
  lib,
  ...
}:
{
  imports = [
    inputs.determinate.nixosModules.default
  ];

  nix.settings = {
    max-jobs = 4;
    cores = 4;
  };

  pilz = {
    shell.enable = true;
    services.ssh.enable = true;
    common.enable = true;
    monitoring.node-exporter.enable = true;
    monitoring.systemd-exporter.enable = true;
  };

  networking = {
    usePredictableInterfaceNames = false;
    useNetworkd = true;
    useDHCP = false;
    domain = "as214958.net";
    nameservers = lib.mkAfter [
      "2606:4700:4700::1111"
      "1.1.1.1"
      "2606:4700:4700::1001"
      "1.0.0.1"
    ];
  };

  security.sudo = {
    execWheelOnly = true;
    wheelNeedsPassword = false;
  };
}
