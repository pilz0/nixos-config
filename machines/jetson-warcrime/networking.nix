{
  networking = {
    hostName = "jetson-warcrime";
    firewall.allowedTCPPorts = [
      22
      8096
    ];
    firewall.allowedUDPPorts = [
      22
      8096
    ];
    useDHCP = true;
  };
}
