{ config, ... }:
{
  services.tor = {
    enable = true;
    openFirewall = true;
    relay = {
      enable = true;
      role = "relay";
    };
    settings = {
      ContactInfo = "darmstadt@fridaysforfuture.de";
      Nickname = "as214958${config.networking.hostName}";
      BandWidthRate = "6 MBytes";
      RelayBandwidthBurst = "12 MBytes";
      ExitRelay = false;
      MyFamily = "2D3BC9AD2530644BBC6A57A92565D08B76AC7DEB, 2FDB1719E6A5E6110F93CE3AC5E841F9B3A2B726, 385486EC538186581947C5DAB4B33ED927DC4E98, 9DBF6C9C640F19E26431B4D272165F3622895AAC, DD068520C3C34EA4223DBD82A111E5AADC419EB7";
    };
  };
}
