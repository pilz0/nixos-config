{ ... }:
{
  users.users = {
    marie = {
      isNormalUser = true;
      description = "marie";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      openssh.authorizedKeys.keys = [
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIBTGgUYUsIAtcbZBqk5Mq0LH2T5KGFjdjAgNIwUf+/LBAAAABHNzaDo= pilz@framewok"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP6weqYi/f7nQzsCr11NVz/7cdmpSq7sU1N+Ag5jM45S daniel@underdesk"
        "ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBAGgIgZKjLpJFdYK1+Ovd1IHQZhdCy2ZIz1Sf8qVGErkNVPkYOU3iJRoK2pJKrotZTo/2oTaSTzxewXKKJQ98toAAAAEc3NoOg== pilz@token2"
      ];
    };
    april = {
      isNormalUser = true;
      description = "april";
      createHome = true;
      extraGroups = [ ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOBF4P4mA/44Hi9966gD0TiaFA29sA36Qq8yLKwaPMaH _4pr1l@yaptop"
      ];
    };
  };
}
