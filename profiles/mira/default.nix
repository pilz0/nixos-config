{ inputs, ... }: {
  imports = [
    inputs.emily-nixfiles.nixosModules.restic
    inputs.emily-nixfiles.nixosModules.nginx
    "${inputs.emily-nixfiles}/config/users/emily"
    ../../modules/services/vaultwarden
  ];
}
