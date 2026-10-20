# upstream only ships an xcodebuild project, so use the signed release dmg
{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "crack";
  version = "1.6.0";

  src = fetchurl {
    url = "https://github.com/ronreiter/crack/releases/download/v${finalAttrs.version}/Crack-${finalAttrs.version}-arm64.dmg";
    hash = "sha256-wd2M99Pzo04efgAwPVqIdq9IFJioOruVktDhBaZmEiI=";
  };

  nativeBuildInputs = [ _7zz ];
  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r Crack.app $out/Applications
    runHook postInstall
  '';

  meta = {
    description = "Make your MacBook lid creak like a squeaky door";
    homepage = "https://github.com/ronreiter/crack";
    license = lib.licenses.mit;
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
