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
    hash = "sha256-D0Jc0BQbsitw4SE0F914UHnEdrc3eZFtCI0hNxSyJeE=";
  };

  vendorHash = "sha256-fTV6hO7IGxoAOF7xzKz+jR6Gwaq5f24rlc7wiT4zCKg=";

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
