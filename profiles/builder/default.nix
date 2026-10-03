{
  pkgs,
  lib,
  ...
}:
{
  nix = {
    settings = {
      trusted-users = lib.mkAfter [ "nix-ssh" ];
    };
    extraOptions = ''
      min-free = ${toString (16384 * 1024 * 1024)}
      max-free = ${toString (32768 * 1024 * 1024)}
      max-substitution-jobs = 48
      http-connections = 64
      max-silent-time = 14400
    '';
    sshServe = {
      enable = true;
      write = true;
      trusted = true;
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE/vCXM3IaxJP9v2Y+xcQrQD2IcffgdzqtWhpMjj9Xl5 hydra@seras"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII1mECV9Etr/nLIgg1E2mpFvAW1RexhhsRKrF7XcDEZI marie@framwok"
      ];
    };
  };

  users.users = {
    emily = {
      extraGroups = [
        "wheel"
      ];
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA/+iN407+HsfHbbC3tfdA8Yf4TZ08qXQMb4tb/SDAs+"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    tmux
    screen
  ];
  boot.tmp.useTmpfs = false;
  virtualisation.docker.enable = true;
}
