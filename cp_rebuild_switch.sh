#!/usr/bin/env bash
set -euo pipefail

script_path="${BASH_SOURCE[0]}"
if [[ "$script_path" == */* ]]; then
    repo_dir="$(cd -- "${script_path%/*}" && pwd -P)"
else
    repo_dir="$(pwd -P)"
fi

SWAY_CONFIG="$repo_dir/home/.config/sway/config"
FLAKE_REF="$repo_dir#nixos"

printf 'Validating Sway config: %s\n' "$SWAY_CONFIG"
sway --unsupported-gpu --validate --config "$SWAY_CONFIG"

sudo nixos-rebuild switch --flake "$FLAKE_REF"

GENERATION_NAME="$(basename "$(readlink /nix/var/nix/profiles/system)")"
printf 'Generation: %s\n' "$GENERATION_NAME"
