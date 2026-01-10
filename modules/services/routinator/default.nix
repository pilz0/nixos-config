{
  services.routinator = {
    enable = true;
    settings = {
      enable-aspa = true;
      rtr-listen = [
        "0.0.0.0:3323"
        "[2a0e:8f02:f017::5]:3323"
      ];
    };
  };
}
