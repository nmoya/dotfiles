#!/usr/bin/env bash
set -euo pipefail


SWAY_CONFIG="./home/.config/sway/config"
echo "Validating Sway config: $SWAY_CONFIG"
sway --unsupported-gpu --validate --config "$SWAY_CONFIG"

sudo cp ./system/configuration.nix /etc/nixos/configuration.nix
sudo nixos-rebuild switch