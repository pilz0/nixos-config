{
  inputs,
  lib,
  config,
  nix-rosetta-builder,
  ...
}:
let
  cfg = config.pilz.services.darwin.rosetta-builder;
in
{
  imports = [
    inputs.nix-rosetta-builder.darwinModules.default
  ];
  options.pilz.services.darwin.rosetta-builder = {
    memory = lib.mkOption {
      type = lib.types.int;
      default = 16;
    };
    cores = lib.mkOption {
      type = lib.types.int;
      default = 8;
    };
    jobs = lib.mkOption {
      type = lib.types.int;
      default = 8;
    };
  };
  config = {
  # enable on setup for rosetta builder
   # nix.linux-builder.enable = true;
#    nix-rosetta-builder = {
#      onDemand = true;
#      onDemandLingerMinutes = 60;
#      cores = cfg.cores;
#      #    jobs = cfg.jobs;
#      memory = "${toString cfg.memory}GiB";

#      potentiallyInsecureExtraNixosModule = {
#        nix.settings = {
#          extra-substituters = [ "https://cache.flakehub.com" ];
#          extra-trusted-public-keys = [
#            "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
#            "cache.flakehub.com-4:Asi8qIv291s0aYLyH6IOnr5Kf6+OF14WVjkE0fT3WuQ="
#            "cache.flakehub.com-5:zB96CRlL7tiPtzA9/WKyPkp3A2vqxqgdgyTVNGShPDU="
#            "cache.flakehub.com-6:W4EGFwAGgBj3he7c5fNh9NkrXy0PC/6FqiLFJeF7wwI="#
#            "cache.flakehub.com-7:mvxJ4DowaVcGWNJZeih+iyvwG8AiEdvT4tlYBZf0pOk="
#          ];
#        };
#      };
#    };
 };
}
