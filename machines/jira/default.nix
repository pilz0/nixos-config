{
  pkgs,
  ...
}:
{
  imports = [
    ../../profiles/vm
  ];

  pilz = {
    services = {
      jira = {
        enable = true;
        crackJar = pkgs.callPackage ../../pkgs/jira-crack.nix { };
      };
      pve-container.network = {
        enable = true;
        address = [
          "10.10.10.20/24"
          "2a0e:8f02:f017::30/64"
        ];
      };
    };
    deployment = {
      targetHost = "jira.ams1.as214958.net";
      tags = [ "infra" ];
    };
  };

  system.stateVersion = "26.11";

  networking = {
    hostName = "jira";
    hostId = "4a1ea201";
  };

  networking.firewall = {
    allowedTCPPorts = [
    ];
    allowedUDPPorts = [
    ];
    extraCommands = ''
      ${pkgs.iptables}/bin/iptables -A INPUT -p tcp --dport 8080 -s 94.142.241.152 -j ACCEPT
      ${pkgs.iptables}/bin/ip6tables -A INPUT -p tcp --dport 8080 -s 2a0e:8f02:f017::2 -j ACCEPT
    '';
  };
}
