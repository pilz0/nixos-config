{
  ...
}:
{
  programs.ssh.extraConfig = ''
    Host eu.nixbuild.net
    PubkeyAcceptedKeyTypes ssh-ed25519
    ServerAliveInterval 60
    IPQoS throughput
    IdentityFile /Users/pilz/.ssh/id_ed25519

    Host build-aarch64.as214958.net
    IdentityFile /Users/pilz/.ssh/id_ed25519
    ServerAliveInterval 60
    IPQoS throughput

    Host build.ams1.as214958.net
    IdentityFile /Users/pilz/.ssh/id_ed25519
    ServerAliveInterval 60
    IPQoS throughput

  '';

  programs.ssh.knownHosts = {
    nixbuild = {
      hostNames = [ "eu.nixbuild.net" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIQCZc54poJ8vqawd8TraNryQeJnvH1eLpIDgbiqymM";
    };
  };

  environment.etc."nix/machines".text = ''
    ssh://root@build-aarch64.as214958.net aarch64-linux - 4 2 benchmark,big-parallel,kvm - -
    ssh://root@eu.nixbuild.net x86_64-linux - 100 1 benchmark,big-parallel,kvm - -
    ssh://root@build.ams1.as214958.net x86_64-linux - 100 3 benchmark,big-parallel - -
    ssh://root@eu.nixbuild.net i686-linux - 100 1 benchmark,big-parallel - -
    ssh://root@eu.nixbuild.net aarch64-linux - 100 1 benchmark,big-parallel - -
  '';

  environment.etc."nix/nix.custom.conf".text = ''
    builders = @/etc/nix/machines
    builders-use-substitutes = true
  '';
}
