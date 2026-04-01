{
  lib,
  ...
}:
{

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = lib.mkDefault false;
      PermitRootLogin = "prohibit-password";
      KbdInteractiveAuthentication = false;
    };
    banner = ''
      <p><div class='plussize'>
      "MRX hatte drei Regeln:
      <BR>Erstens: Kein System ist sicher
      <BR>Zweitens: Dreistigkeit siegt
      <BR>Drittens: begrenze Deinen Spass nicht nur auf die virtuelle Welt"
      </div>
      _____________________________________________________________________
      <p><div class='plussize'>"Du musst nur dreist genug sein, dann liegt Dir die Welt zu Füßen."</div>
    '';
  };
  users.users = {
    marie = {
      isNormalUser = true;
      initialPassword = "foobar1312";
      description = "marie";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      openssh.authorizedKeys.keys = [
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIBTGgUYUsIAtcbZBqk5Mq0LH2T5KGFjdjAgNIwUf+/LBAAAABHNzaDo= pilz@framewok"
        "ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBAGgIgZKjLpJFdYK1+Ovd1IHQZhdCy2ZIz1Sf8qVGErkNVPkYOU3iJRoK2pJKrotZTo/2oTaSTzxewXKKJQ98toAAAAEc3NoOg== pilz@token2"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII1mECV9Etr/nLIgg1E2mpFvAW1RexhhsRKrF7XcDEZI marie@framwok"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExU28oRh+stgLtfgqUejL601PPV8OKqoVni9W6dna9a"
      ];
    };
    root = {
      openssh.authorizedKeys.keys = [
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIBTGgUYUsIAtcbZBqk5Mq0LH2T5KGFjdjAgNIwUf+/LBAAAABHNzaDo= pilz@framewok"
        "ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBAGgIgZKjLpJFdYK1+Ovd1IHQZhdCy2ZIz1Sf8qVGErkNVPkYOU3iJRoK2pJKrotZTo/2oTaSTzxewXKKJQ98toAAAAEc3NoOg== pilz@token2"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII1mECV9Etr/nLIgg1E2mpFvAW1RexhhsRKrF7XcDEZI marie@framwok"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExU28oRh+stgLtfgqUejL601PPV8OKqoVni9W6dna9a"
      ];
    };
  };

}
