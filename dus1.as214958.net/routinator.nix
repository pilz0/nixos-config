{
  ...
}:
{
  services.routinator = {
    enable = true;
    settings = {
      rtr-listen = [ "[::1]:8362" ];
    };
  };
}
