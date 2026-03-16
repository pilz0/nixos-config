{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.pilz.services.darwin.colima;
in
{
  options.pilz.services.darwin.colima = {
    user = lib.mkOption {
      type = lib.types.str;
      default = "pilz";
    };
  };

  config = {
    environment.systemPackages = with pkgs; [
      docker
      docker-compose
      colima
    ];

    # why is docker aahhh
    # https://github.com/nix-darwin/nix-darwin/issues/1182
    launchd.agents."colima.default" = {
      command = "${pkgs.colima}/bin/colima start --foreground";
      serviceConfig = {
        Label = "com.colima.default";
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = "/Users/${cfg.user}/.colima/default/daemon/launchd.stdout.log";
        StandardErrorPath = "/Users/${cfg.user}/.colima/default/daemon/launchd.stderr.log";
        EnvironmentVariables = {
          PATH = "${pkgs.colima}/bin:${pkgs.docker}/bin:/usr/bin:/bin:/usr/sbin:/sbin";

        };
      };
    };
  };
}
