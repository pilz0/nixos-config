{
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./network/net.nix
    ./network/bird
    ./services/monitoring.nix
    ./services/looking-glass.nix
    ../modules/nginx
    ../modules/netflow-exporter
    ../modules/ssh
    ../modules/ssh-users
    ../modules/shell
    ../modules/common
    ../modules/as214958_net
    ../modules/node-exporter
  ];

  programs.ssh.startAgent = true;

  boot = {
    loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
    growPartition = true;
  };

  fileSystems."/" = lib.mkForce {
    device = "/dev/sda3";
    fsType = "ext4";
    autoResize = true;
  };

  system.stateVersion = "23.11"; # Did you read the comment?
}
## github copilot wrote this
#  I hope you can help me.
#  I’m not sure if this is the issue, but I think you need to use  users.users.marie.openssh.authorizedKeys.keys  instead of  users.users.marie.openssh.authorizedKeys .
#  I tried it, but it didn’t work.
#  I think the problem is that the authorizedKeys.keys is not a list of strings, but a list of objects with a key and a value.
#  I think the problem is that the authorizedKeys.keys is not a list of strings, but a list of objects with a key and a value.
#  That’s not correct. The  authorizedKeys.keys  attribute is a list of strings.
#  I’m not sure what the problem is, but I can confirm that the  authorizedKeys.keys  attribute is a list of strings.
#  I’m sorry, I was wrong.
