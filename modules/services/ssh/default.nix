{
  lib,
  config,
  ...
}:
# partly from https://woof.rip/emily/nixfiles/src/branch/main/config/common/openssh.nix
with lib;
let
  ciphers = [
    "chacha20-poly1305@openssh.com"
    "aes256-gcm@openssh.com"
    "aes128-gcm@openssh.com"
  ];

  sigAlgorithms = [
    "ssh-ed25519-cert-v01@openssh.com"
    "ssh-ed25519"
    "sk-ssh-ed25519-cert-v01@openssh.com"
    "sk-ssh-ed25519@openssh.com"
  ];

  kexAlgorithms = [
    "sntrup761x25519-sha512@openssh.com"
    "curve25519-sha256"
    "curve25519-sha256@libssh.org"
  ];

  macs = [
    "umac-128-etm@openssh.com"
    "hmac-sha2-512-etm@openssh.com"
    "hmac-sha2-256-etm@openssh.com"
  ];
in
{
  options.pilz.services.ssh.enable = lib.mkEnableOption "";
  config = lib.mkIf config.pilz.services.ssh.enable {
    programs.ssh = {
      startAgent = true;
      inherit ciphers kexAlgorithms macs;
      hostKeyAlgorithms = sigAlgorithms;
      pubkeyAcceptedKeyTypes = sigAlgorithms;
    };

    services.openssh = {
      enable = true;
      hostKeys = mkDefault [
        {
          type = "ed25519";
          path = "/etc/keys/ssh_host_ed25519_key";
        }
      ];
      settings = {
        PasswordAuthentication = lib.mkDefault false;
        PermitRootLogin = "prohibit-password";
        KbdInteractiveAuthentication = false;
      };
      settings.Banner = builtins.toFile "ssh-banner" ''
        <p><div class='plussize'>
        "MRX hatte drei Regeln:
        <BR>Erstens: Kein System ist sicher
        <BR>Zweitens: Dreistigkeit siegt
        <BR>Drittens: begrenze Deinen Spass nicht nur auf die virtuelle Welt"
        </div>
        _____________________________________________________________________
        <p><div class='plussize'>"Du musst nur dreist genug sein, dann liegt Dir die Welt zu Füßen."</div>
      '';
      settings.Ciphers = ciphers;
      settings.Macs = macs;

      settings.KexAlgorithms = kexAlgorithms;
      settings.HostKeyAlgorithms = concatStringsSep "," sigAlgorithms;
      settings.PubkeyAcceptedAlgorithms = concatStringsSep "," sigAlgorithms;

      settings.StreamLocalBindUnlink = true;
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
  };
}
