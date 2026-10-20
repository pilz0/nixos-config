{
  config,
  lib,
  ...
}:
{
  # hosts with gcc.arch get no cache hits, so everything builds on the (busy) builder;
  # skip tests that flake under load there. untuned hosts keep their cache hits.
  nixpkgs.overlays = lib.mkIf ((config.nixpkgs.hostPlatform.gcc or { }) ? arch) [
    (_: prev: {
      # counterexample search (test 270) hits its time limit on a loaded machine
      bison = prev.bison.overrideAttrs { doInstallCheck = false; };
    })
  ];
}
