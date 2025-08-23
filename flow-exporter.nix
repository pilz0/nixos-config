{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "flow-exporter";
  version = "1.1.1";

  src = fetchFromGitHub {
    rev = "master";
    owner = "pilz0";
    repo = "flow-exporter";
    sha256 = "sha256-GvXgE0tkdYJ8C35XH5lUi/GC2KZAQWQbdnS1aSSKxIY=";
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
