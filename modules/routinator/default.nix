{
  ...
}:
{
  services.routinator = {
    enable = true;
    settings = {
      rtr-listen = [ "10.10.10.5:3323" ];
    };
  };
}
