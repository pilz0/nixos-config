{
  config,
  ...
}:
{
  age.secrets.HashedPassword = {
    file = ../../secrets/HashedPassword.age;
    owner = "marie";
    group = "users";
  };
  users.users = {
    marie = {
      hashedPasswordFile = config.age.secrets.HashedPassword.path;
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
