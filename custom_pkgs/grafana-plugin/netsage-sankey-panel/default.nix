{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "netsage-sankey-panel";
  version = "1.1.4";
  zipHash = "sha256-z5Np45xdv3zXww+uvmMlN/brRgwT9yCjl+pNpWH7Ky4=";
  meta = with lib; {
    description = "Panel plugin for generating Sankey diagrams in Grafana 7.0+. Sankey diagrams are good for visualizing flow data and the width of the flows will be proportionate to the selected metric.";
    license = licenses.asl20;
    maintainers = with maintainers; [ pilz ];
    platforms = platforms.unix;
  };
}
