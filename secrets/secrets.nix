let
  #marieyubi = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIBTGgUYUsIAtcbZBqk5Mq0LH2T5KGFjdjAgNIwUf+/LBAAAABHNzaDo= pilz@framewok";
  #marietoken2 = "ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBAGgIgZKjLpJFdYK1+Ovd1IHQZhdCy2ZIz1Sf8qVGErkNVPkYOU3iJRoK2pJKrotZTo/2oTaSTzxewXKKJQ98toAAAAEc3NoOg== pilz@token2";
  marielap = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII1mECV9Etr/nLIgg1E2mpFvAW1RexhhsRKrF7XcDEZI marie@framwok"; # # Laptop
  Laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINxK1XaK+2oivpGVJ/vYRrqbWhaYE6hEgmDOfkGvde8L root@framwok";
  serva = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOFNa2EBrRNnGMjGSNjlD1pXo9YRuq6rOsC3v+6VAg2F root@nixos";

in
{
  "nextcloud.age".publicKeys = [
    marielap
    serva
  ];
  "nextcloud-secrets.age".publicKeys = [
    marielap
    serva
  ];
  "rclone.age".publicKeys = [
    Laptop
    marielap
    serva
  ];
  "restic.age".publicKeys = [
    Laptop
    marielap
    serva
  ];
  "smtp.age".publicKeys = [
    marielap
    serva
  ];
  "grafana.age".publicKeys = [
    marielap
    serva
  ];
  "writefreely.age".publicKeys = [
    marielap
    serva
  ];
  "nextcloud-exporter.age".publicKeys = [
    marielap
    serva
  ];
  "wg.age".publicKeys = [
    marielap
    serva
  ];
  "nixarr-wg.age".publicKeys = [
    marielap
    serva
  ];
  "HashedPassword.age".publicKeys = [
    marielap
    Laptop
    serva
  ];
  "traewelling.age".publicKeys = [
    marielap
    serva
  ];
  "cloudflare_cert.age".publicKeys = [
    marielap
    serva
  ];
  "cloudflare_key.age".publicKeys = [
    marielap
    serva
  ];
  "s3-mastodon.age".publicKeys = [
    marielap
    serva
  ];
}
