#!/usr/bin/env bash
set -euo pipefail

grafana_store_path=$(nix eval --raw .#checks.aarch64-linux.grafana.outPath --accept-flake-config)
drupal_store_path=$(nix eval --raw .#checks.aarch64-linux.drupal.outPath --accept-flake-config)
as214958_net_store_path=$(nix eval --raw .#checks.aarch64-linux.as214958net.outPath --accept-flake-config)

nix-store --delete "$grafana_store_path" --verbose
nix-store --delete "$drupal_store_path" --verbose
nix-store --delete "$as214958_net_store_path" --verbose

nix build .#checks.aarch64-linux.grafana --verbose --accept-flake-config
nix build .#checks.aarch64-linux.drupal --verbose --accept-flake-config
nix build .#checks.aarch64-linux.as214958net --verbose --accept-flake-config

