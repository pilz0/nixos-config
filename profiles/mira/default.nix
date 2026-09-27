{ inputs, ... }: {
  imports = [
    inputs.emily-nixfiles.nixosModules.restic
    inputs.emily-nixfiles.nixosModules.nginx
    inputs.emily-nixfiles.nixosModules.anubis
    inputs.emily-nixfiles.nixosModules.machine-type
    "${inputs.emily-nixfiles}/config/users/emily"
    ../../modules/services/vaultwarden
    ../../modules/services/forgejo
  ];
}
