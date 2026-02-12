{
  pkgs,
  ...
}:
{
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
      StandardOutPath = "/Users/pilz/.colima/default/daemon/launchd.stdout.log";
      StandardErrorPath = "/Users/pilz/.colima/default/daemon/launchd.stderr.log";
      EnvironmentVariables = {
        PATH = "${pkgs.colima}/bin:${pkgs.docker}/bin:/usr/bin:/bin:/usr/sbin:/sbin";
      };
    };
  };

}
