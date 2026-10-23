{
  lib,
  stdenvNoCC,
  fetchurl,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "jira-crack";
  version = "3.4.6";

  src = fetchurl {
    url = "https://github.com/ninja-js/jira-crack/raw/master/atlassian-extras-${finalAttrs.version}.jar";
    hash = "sha256-ZLayfotkEqD/BtS/8JZFOiLz9e2f17z/aiwyjJhrDBI=";
  };

  nativeBuildInputs = [ ];
  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/jira-crack
    cp $src $out/share/jira-crack/atlassian-extras-${finalAttrs.version}.jar
    runHook postInstall
  '';

  meta = {
    description = "Jira crack jar file to accept old license keys";
    homepage = "https://github.com/ninja-js/jira-crack";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
})
