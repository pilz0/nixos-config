{
  modulesPath,
  ...
}:
{
  imports = [
    "${modulesPath}/virtualisation/proxmox-lxc.nix"
    ../ssh
    ../ssh-users
    ../shell
    ../common
    ../monitoring/node-exporter
    ../promtail
    ../common/pkgs
    ../nixos-builder-client
    ../../lib/lxc
  ];
  proxmoxLXC = {
    manageNetwork = false;
    privileged = false;
    manageHostName = false;
  };
}
