{
  inputs,
  modulesPath,
  ...
}:
{
  imports = [
    ./network.nix
    inputs.determinate.nixosModules.default
    "${modulesPath}/virtualisation/proxmox-lxc.nix"
    # ../../modules/monitoring/promtail
    ../../lib/lxc
  ];

  pilz = {
    shell.enable = true;
    services.ssh.enable = true;
    monitoring.node-exporter.enable = true;
    monitoring.systemd-exporter.enable = true;
    common.enable = true;
  };

  proxmoxLXC = {
    manageNetwork = false;
    privileged = false;
    manageHostName = false;
  };

  documentation.man.cache.enable = false;
  
  security.sudo = {
    enable = true;
    execWheelOnly = true;
    wheelNeedsPassword = false;
  };
}
