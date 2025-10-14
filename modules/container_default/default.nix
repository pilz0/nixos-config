{
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [
    "${modulesPath}/virtualisation/lxc-container.nix"
  ];
  networking.useHostResolvConf = false;
  networking.nameservers = [
    "1.1.1.1"
    "2606:4700:4700::1111"
  ];
  systemd.network = {
    enable = true;
    networks = {
      "10-eth0" = {
        networkConfig = {
          IPv6AcceptRA = true;
        };
        matchConfig.Name = "eth0";
        routes = [
          {
            Gateway = "10.10.10.1";
            Destination = "0.0.0.0/0";
            GatewayOnLink = true;
          }
          {
            Gateway = "2a0e:8f02:f017::1";
            Destination = "::/0";
          }
        ];
        linkConfig.RequiredForOnline = "routable";
      };
    };
    config = {
      networkConfig = {
        # https://github.com/systemd/systemd/issues/36347
        ManageForeignRoutes = false;
        ManageForeignRoutingPolicyRules = false;
        IPv4Forwarding = true;
        IPv6Forwarding = true;
      };
    };
    wait-online = {
      enable = false;
      anyInterface = false;
    };
  };
  boot.kernel.sysctl = {
    "net.ipv6.conf.eth0.accept_dad" = false;
    "net.ipv6.conf.eth0.dad_transmits" = false;
    "net.ipv6.conf.default.accept_dad" = false;
    "net.ipv6.conf.default.dad_transmits" = false;
  };
  boot.isContainer = true;
  programs.ssh.startAgent = true;

  environment.systemPackages = with pkgs; [
    keychain
  ];

  programs.zsh.interactiveShellInit = ''
    eval $(keychain --eval --quiet id_rsa)
  '';

  boot = {
    loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
    growPartition = true;
  };

  system.stateVersion = "23.11"; # Did you read the comment?

}
