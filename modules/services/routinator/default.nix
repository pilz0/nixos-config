{
  services.routinator = {
    enable = true;
    settings = {
      enable-aspa = true;
      rtr-listen = [ "10.10.10.5:3323" ];
    };
  };
}
