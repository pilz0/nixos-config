# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  ...
}:
{
  users.users = {
    marie = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIBTGgUYUsIAtcbZBqk5Mq0LH2T5KGFjdjAgNIwUf+/LBAAAABHNzaDo= pilz@framewok"
      ];
      extraGroups = [
        "wheel"
        "networkmanager"
        "dialout"
        "docker"
      ];
    };
  };
}
