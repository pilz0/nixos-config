{
  modulesPath,
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    "${modulesPath}/virtualisation/lxc-container.nix"
    ../ssh
    ../ssh-users
    ../shell
    ../common
    ../node-exporter
  ];

  systemd.suppressedSystemUnits = [
    "dev-mqueue.mount"
    "sys-kernel-debug.mount"
    "sys-fs-fuse-connections.mount"
    "zfs-zed.service"
  ];

  networking = {
    useNetworkd = true;
    domain = "ams1.as214958.net";
    useHostResolvConf = false;
    nameservers = [
      "2606:4700:4700::1111"
      "1.1.1.1"
      "2606:4700:4700::1001"
      "1.0.0.1"
    ];

    firewall = {
      allowedTCPPorts = [ 22 ];
      extraCommands = ''
        ${pkgs.iptables}/bin/ip6tables -A INPUT -p tcp --dport 9100 -i eth0 -s 2a0e:8f02:f017::3 -j ACCEPT
      '';
    };
    extraHosts = ''
      ::1 ${config.networking.fqdn}
      ::1 ${config.networking.hostName}
    '';
  };
  boot = {
    isContainer = true;
    kernel.sysctl = {
      "net.ipv6.conf.eth0.accept_dad" = false;
      "net.ipv6.conf.eth0.dad_transmits" = false;
      "net.ipv6.conf.default.accept_dad" = false;
      "net.ipv6.conf.default.dad_transmits" = false;
    };
    loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
    growPartition = true;
    tmp.useTmpfs = lib.mkDefault true;
  };

  programs.ssh.startAgent = true;

  environment.systemPackages = with pkgs; [
    keychain
  ];

  system.stateVersion = "23.11"; # Did you read the comment?
}
