{
  networking = {
    hostName = "jetson-warcrime";
    firewall.allowedTCPPorts = [
      22
      8096
      3069
    ];
    firewall.allowedUDPPorts = [
      22
      8096
      3069
    ];
    useDHCP = true;
  };
}
