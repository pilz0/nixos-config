{
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "fruit:aapl" = "yes";
        "fruit:model" = "MacSamba";
        "fruit:nfs_aces" = "no";
        "ea support" = "yes";
        "vfs objects" = "catia fruit streams_xattr";
      };
      "tm_share" = {
        "path" = "/srv/timemachine";
        "valid users" = "marie";
        "public" = "no";
        "writeable" = "yes";
        "force user" = "marie";
        "fruit:time machine" = "yes";
        "vfs objects" = "catia fruit streams_xattr";
        "spotlight" = "no";
        "create mask" = "0600";
        "directory mask" = "0700";
      };
    };
  };
}