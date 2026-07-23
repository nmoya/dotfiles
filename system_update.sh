#!/usr/bin/env bash
set -euo pipefail

script_path="${BASH_SOURCE[0]}"
if [[ "$script_path" == */* ]]; then
    repo_dir="$(cd -- "${script_path%/*}" && pwd -P)"
else
    repo_dir="$(pwd -P)"
fi

nix flake update --flake "$repo_dir"
sudo nixos-rebuild switch --flake "$repo_dir#nixos"
