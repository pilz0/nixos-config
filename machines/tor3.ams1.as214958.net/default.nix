{
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./net.nix
    ./tor.nix
    ../../modules/container_default
    ../../modules/nixos-builder-client
    ../../modules/tor-relay
    ../../modules/tor-relay/network-pve.nix

  ];
}
