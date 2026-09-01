{
  inputs,
  modulesPath,
  ...
}:
{
  imports = [
    ../importAll
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
    services.nixosBuilderClient.enable = true;
    #services.promtail.enable = true;
    common.enable = true;
  };

  proxmoxLXC = {
    manageNetwork = false;
    privileged = false;
    manageHostName = false;
  };

  documentation.man.generateCaches = false;

  security.sudo = {
    enable = true;
    execWheelOnly = true;
    wheelNeedsPassword = false;
  };
}
