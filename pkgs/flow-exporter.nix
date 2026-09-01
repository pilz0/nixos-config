{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "flow-exporter";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "pilz0";
    repo = "flow-exporter";
    rev = "multiple_metrics";
    # haschisch rauchen !!!!
    hash = "sha256-f9LdOGKE+h9JyBc5EyyFWU4SeEsBgcfWRY5VuPTsAdc=";
  };

  vendorHash = "sha256-HwQt+PZxtftMuIULTgohYpIsGM6+mX0fku5xcU7rmn0=";

  meta = with lib; {
    description = "Export network flows from kafka to Prometheus";
    mainProgram = "flow-exporter";
    homepage = "https://github.com/neptune-networks/flow-exporter";
    license = licenses.mit;
    maintainers = with maintainers; [
      kloenk
      pilz0
    ];
    platforms = platforms.linux;
  };
})
