{
  networking = {
    hostName = "jetson-warcrime";
    firewall.allowedTCPPorts = [ 22 ];
    useDHCP = true;
  };
}
