{
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./net.nix
    ../../modules/nginx
    ../../modules/as214958_net
    ../../modules/container_default
    ../../modules/bird-lg-frontend
    ./proxys.nix
    ../../modules/nixos-builder-client
  ];
  virtualisation.docker.enable = true;
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
