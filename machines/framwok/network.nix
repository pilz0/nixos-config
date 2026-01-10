{
  pkgs,
  ...
}:
{
  networking = {
    firewall.enable = false;
    hostName = "framwok";
    domain = "pilz.foo";
    #extraHosts = ''
    #  10.40.20.70 trenton
    #'';
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openvpn
      ];
    };
  };
}
