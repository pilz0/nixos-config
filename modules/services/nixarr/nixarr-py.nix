# upstream python-deps.nix lacks the openapi hash for jellyfin 12.4; drop once nixarr adds it
{
  lib,
  pkgs,
  nixarr,
  jellyfin,
}:
pkgs.python3Packages.buildPythonPackage {
  pname = "nixarr-py";
  version = "0.1.0";
  pyproject = true;
  src = "${nixarr}/nixarr/lib/nixarr-py";
  build-system = [ pkgs.python3Packages.setuptools ];
  dependencies = pkgs.callPackage "${nixarr}/nixarr/lib/nixarr-py/python-deps.nix" {
    inherit jellyfin;
    fetchurl =
      args:
      pkgs.fetchurl (
        args
        // lib.optionalAttrs (lib.hasSuffix "jellyfin-openapi-12.4.json" args.url) {
          hash = "sha256-AqYGSRa34I8fHY1//B+xx2I98ON4cp/Nf9NTdmhoA24=";
        }
      );
  };
}
