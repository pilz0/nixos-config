{
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      "tm_share" = {
        "path" = "/srv/timemachine";
        "valid users" = "marie";
        "public" = "no";
        "writeable" = "yes";
        "force user" = "marie";
        "fruit:aapl" = "yes";
        "fruit:time machine" = "yes";
        "vfs objects" = "catia fruit streams_xattr";
      };
    };
  };
}
