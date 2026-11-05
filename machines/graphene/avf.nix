{ inputs, lib, ... }:
let
  avf = import "${inputs.nixos-avf}/avf";
  wrapped =
    args:
    let
      m = avf args;
    in
    m
    // {
      config = m.config // {
        boot = m.config.boot // {
          initrd = removeAttrs m.config.boot.initrd [ "systemd" ];
        };
      };
    };
in
{
  imports = [
    {
      _file = "${inputs.nixos-avf}/avf/default.nix";
      imports = [ (lib.setFunctionArgs wrapped (lib.functionArgs avf)) ];
    }
  ];
}
