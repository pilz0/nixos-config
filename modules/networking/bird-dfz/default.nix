{
  lib,
  ...
}:
{
  services.bird = {
    config = lib.mkOrder 1 ''
      # Inject received BGP routes into the Linux kernel
      protocol kernel krnv4 {
      scan time 20;
      ipv4 {
        import none;
        export all;
      };
      }

      protocol kernel krnv6 {
      scan time 20;
      ipv6 {
        import none;
        export all;
      };
      }
    '';
  };
}
