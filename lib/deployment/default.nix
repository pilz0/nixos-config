{
  lib,
  ...
}:
with lib;
{
  options.pilz.deployment = {
    tags = mkOption {
      type = with types; listOf str;
      default = [ ];
      description = "colmena deployment tags";
    };
    targetHost = mkOption {
      type = with types; nullOr str;
      default = null;
      description = "colmena target host override";
    };
    allowLocalDeployment = mkOption {
      type = with types; nullOr bool;
      default = false;
      description = "allow colmena local deployment";
    };
    targetUser = mkOption {
      type = with types; nullOr str;
      default = "root";
      description = "colmena target user";
    };
    targetPort = mkOption {
      type = with types; nullOr int;
      default = 22;
      description = "colmena target ssh port";
    };
  };
}
