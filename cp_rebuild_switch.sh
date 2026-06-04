#!/usr/bin/env bash
set -euo pipefail


sudo cp ./system/configuration.nix /etc/nixos/configuration.nix

sudo nixos-rebuild switch