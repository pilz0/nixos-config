let
  #marieyubi = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIBTGgUYUsIAtcbZBqk5Mq0LH2T5KGFjdjAgNIwUf+/LBAAAABHNzaDo= pilz@framewok";
  #marietoken2 = "ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBAGgIgZKjLpJFdYK1+Ovd1IHQZhdCy2ZIz1Sf8qVGErkNVPkYOU3iJRoK2pJKrotZTo/2oTaSTzxewXKKJQ98toAAAAEc3NoOg== pilz@token2";
  marie = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOFNa2EBrRNnGMjGSNjlD1pXo9YRuq6rOsC3v+6VAg2F root@nixos";
  marielap = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII1mECV9Etr/nLIgg1E2mpFvAW1RexhhsRKrF7XcDEZI marie@framwok";

  users = [
    marie

  ];

  serva = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOFNa2EBrRNnGMjGSNjlD1pXo9YRuq6rOsC3v+6VAg2F root@nixos";
  systems = [ serva ];

in
{
  "nextcloud.age".publicKeys = [
    marielap
    marie
    serva
  ];
  "nextcloud-secrets.age".publicKeys = [
    marielap
    marie
    serva
  ];
  "rclone.age".publicKeys = [
    marielap
    marie
    serva
  ];
  "restic.age".publicKeys = [
    marielap
    marie
    serva
  ];
  "smtp.age".publicKeys = [
    marielap
    marie
    serva
  ];
  "grafana.age".publicKeys = [
    marielap
    marie
    serva
  ];
  "writefreely.age".publicKeys = [
    marielap
    marie
    serva
  ];
  "nextcloud-exporter.age".publicKeys = [
    marielap
    marie
    serva
  ];
  "wg.age".publicKeys = [
    marielap
    marie
    serva
  ];
  "nixarr-wg.age".publicKeys = [
    marielap
    marie
    serva
  ];
  "HashedPassword.age".publicKeys = [
    marielap
    marie
    serva
  ];
}
