{
  modulesPath,
  ...
}:
{
  imports = [
    "${modulesPath}/virtualisation/proxmox-lxc.nix"
    ../ssh
    ../shell
    ../common
    ../monitoring/node-exporter
    # ../monitoring/promtail
    ../common/pkgs
    ../nixos-builder-client
    ../../lib/lxc
  ];
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

  pilz.services.nixosBuilderClient.enable = true;
  #pilz.services.promtail.enable = true;
}
