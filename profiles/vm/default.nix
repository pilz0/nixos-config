{
  inputs,
  modulesPath,
  config,
  lib,
  ...
}:
{
  imports = [
    "${modulesPath}/virtualisation/proxmox-image.nix"
    inputs.determinate.nixosModules.default
    ../container/network.nix
  ];

  proxmox = {
    cloudInit.enable = false;
    qemuConf = {
      name = config.networking.hostName;
      cores = lib.mkDefault 2;
      memory = lib.mkDefault 2048;
      additionalSpace = lib.mkDefault "8G";
      net0 = lib.mkDefault "virtio,bridge=vmbr0";
    };
    qemuExtraConf = {
      ide2 = lib.mkForce "none,media=cdrom";
    }
    // lib.optionalAttrs config.pilz.networking.tor-relay.enable {
      net1 = "virtio,bridge=vmbr2";
    };
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
    domain = "ams1.as214958.net";
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
