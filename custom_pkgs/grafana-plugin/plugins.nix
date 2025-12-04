{ callPackage }:
{
  inherit callPackage;

  grafanaPlugin = callPackage ./grafana-plugin.nix { };

  yesoreyeram-infinity-datasource = callPackage ./yesoreyeram-infinity-datasource { };

}
