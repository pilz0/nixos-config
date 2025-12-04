{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "flow-exporter";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "pilz0";
    repo = "flow-exporter";
    rev = "add_metrics_2";
    # haschisch rauchen !!!!
    hash = "sha256-B2ua0jpiyIt0wZUmuz/JAjQF2/I7bUpvLUDcUNlcPqA=";
  };

  vendorHash = "sha256-2raOUOPiMUMydIsfSsnwUAAiM7WyMio1NgL1EoADr2s=";

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
