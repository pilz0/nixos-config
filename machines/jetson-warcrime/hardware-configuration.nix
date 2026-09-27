{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/5dbcad82-0ef8-4b9f-89c2-ea4df317db27";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/8716-673B";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };
  };
}
