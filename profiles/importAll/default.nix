{
  imports = [
    ../../modules/audio
    ../../modules/common
    ../../modules/common/pkgs
    ../../modules/monitoring/blackbox-exporter
    ../../modules/monitoring/grafana
    ../../modules/monitoring/loki
    ../../modules/monitoring/netflow-exporter
    ../../modules/monitoring/node-exporter
    ../../modules/monitoring/systemd-exporter
    ../../modules/monitoring/prometheus
    ../../modules/monitoring/promtail
    ../../modules/nixos-builder-client
    ../../modules/services/as214958-net
    ../../modules/services/diyhrt-web
    ../../modules/services/bird-lg-frontend
    ../../modules/services/nginx
    ../../modules/services/nixarr
    ../../modules/services/routinator
    ../../modules/services/testfile
    ../../modules/services/tor-relay
    ../../modules/services/tor-relay/network-pve.nix
    ../../modules/services/ssh
    ../../modules/services/restic-client
    ../../modules/services/netbox
    ../../modules/services/knot-dns
    ../../modules/services/timemachine-server
    ../../modules/services/nextcloud
    ../../modules/shell
    ../../modules/services/flohannes-de
    ../../modules/services/haos-vm
  ];
}
# missing:
# networking
