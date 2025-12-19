{
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./net.nix
    ./tor.nix
    ../../modules/container-default
    ../../modules/nixos-builder-client
    ../../modules/services/tor-relay
    ../../modules/services/tor-relay/network-pve.nix
  ];
}
