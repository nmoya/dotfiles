#!/usr/bin/env bash
set -euo pipefail

required_commands=(curl jq nvd nix-build nixos-version column stat date readlink uname mktemp)
for command_name in "${required_commands[@]}"; do
    if ! command -v "$command_name" >/dev/null 2>&1; then
        printf 'Missing required command: %s\n' "$command_name" >&2
        exit 1
    fi
done

root_channels="/nix/var/nix/profiles/per-user/root/channels"
nixos_config="/etc/nixos/configuration.nix"
current_system="/run/current-system"
booted_system="/run/booted-system"
system_profile="/nix/var/nix/profiles/system"
script_path="${BASH_SOURCE[0]}"
if [[ "$script_path" == */* ]]; then
    script_dir="$(cd -- "${script_path%/*}" && pwd -P)"
else
    script_dir="$(pwd -P)"
fi
install_date_file="$script_dir/os_installation_date"

if [[ ! -d "$root_channels" ]]; then
    printf 'Root channel profile not found: %s\n' "$root_channels" >&2
    exit 1
fi

if [[ ! -f "$nixos_config" ]]; then
    printf 'NixOS configuration not found: %s\n' "$nixos_config" >&2
    exit 1
fi

now_epoch="$(date +%s)"

format_age() {
    local epoch="$1"
    if [[ -z "$epoch" || "$epoch" == "0" ]]; then
        printf 'unknown'
        return
    fi

    local seconds=$((now_epoch - epoch))
    if (( seconds < 0 )); then
        printf 'in the future'
        return
    fi

    local days=$((seconds / 86400))
    local hours=$(((seconds % 86400) / 3600))
    local minutes=$(((seconds % 3600) / 60))

    if (( days > 0 )); then
        printf '%dd %dh ago' "$days" "$hours"
    elif (( hours > 0 )); then
        printf '%dh %dm ago' "$hours" "$minutes"
    elif (( minutes > 0 )); then
        printf '%dm ago' "$minutes"
    else
        printf 'just now'
    fi
}

format_date() {
    local epoch="$1"
    if [[ -z "$epoch" || "$epoch" == "0" ]]; then
        printf 'unknown'
        return
    fi

    date --date="@$epoch" '+%Y-%m-%d %H:%M:%S %Z'
}

short_hash() {
    local value="$1"
    if [[ ${#value} -gt 12 ]]; then
        printf '%s' "${value:0:12}"
    else
        printf '%s' "$value"
    fi
}

split_nixos_version() {
    local version="$1"
    if [[ "$version" =~ ^([0-9]+\.[0-9]+\.[0-9]+)\.([0-9a-f]{7,40})$ ]]; then
        printf '%s\t%s\n' "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
    elif [[ "$version" =~ ^([0-9]+\.[0-9]+)\.([0-9a-f]{7,40})$ ]]; then
        printf '%s\t%s\n' "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
    else
        printf '%s\tunknown\n' "$version"
    fi
}

discover_channel_name() {
    local manifest="$root_channels/manifest.nix"
    local manifest_text=""
    local current_version="$1"

    if [[ -f "$manifest" ]]; then
        manifest_text="$(<"$manifest")"
        if [[ "$manifest_text" =~ name[[:space:]]*=[[:space:]]*\"(nixos-[^\"]+)\" ]]; then
            printf '%s' "${BASH_REMATCH[1]}"
            return
        fi
    fi

    if [[ "$current_version" =~ ^([0-9]+\.[0-9]+) ]]; then
        printf 'nixos-%s' "${BASH_REMATCH[1]}"
        return
    fi

    printf 'nixos-unstable'
}

first_generation_info() {
    local path
    local base
    local number
    local oldest_number=999999999
    local oldest_path=""
    local count=0

    for path in /nix/var/nix/profiles/system-*-link; do
        [[ -e "$path" ]] || continue
        base="${path##*/}"
        number="${base#system-}"
        number="${number%-link}"
        [[ "$number" =~ ^[0-9]+$ ]] || continue
        count=$((count + 1))
        if (( number < oldest_number )); then
            oldest_number="$number"
            oldest_path="$path"
        fi
    done

    if [[ -n "$oldest_path" ]]; then
        printf '%s\t%s\t%s\n' "$oldest_number" "$count" "$(stat -c %Y "$oldest_path")"
    else
        printf 'unknown\t0\t0\n'
    fi
}

current_generation_number() {
    local target
    local base

    target="$(readlink "$system_profile" 2>/dev/null || true)"
    base="${target##*/}"
    if [[ "$base" =~ ^system-([0-9]+)-link$ ]]; then
        printf '%s' "${BASH_REMATCH[1]}"
    else
        printf 'unknown'
    fi
}

boot_time_epoch() {
    local field
    local value

    while read -r field value; do
        if [[ "$field" == "btime" ]]; then
            printf '%s' "$value"
            return
        fi
    done < /proc/stat

    printf '0'
}

installation_epoch_from_file() {
    local line

    if [[ ! -f "$install_date_file" ]]; then
        return 1
    fi

    while IFS= read -r line; do
        [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
        date --date="$line" +%s
        return
    done < "$install_date_file"

    return 1
}

create_install_date_file() {
    local epoch="$1"

    [[ "$epoch" != "0" ]] || return 1
    [[ ! -e "$install_date_file" ]] || return 1

    {
        printf '# NixOS installation date used by check_system_update.sh.\n'
        printf '# Manually update this after a fresh installation.\n'
        date --date="@$epoch" --iso-8601=seconds
    } > "$install_date_file"
}

current_json="$(nixos-version --json)"
current_version="$(jq -r '.nixosVersion' <<<"$current_json")"
current_revision="$(jq -r '.nixpkgsRevision' <<<"$current_json")"
current_semver=""
current_version_hash=""
IFS=$'\t' read -r current_semver current_version_hash < <(split_nixos_version "$current_version")

channel_name="$(discover_channel_name "$current_version")"
channel_url="https://channels.nixos.org/$channel_name"
remote_revision="$(curl --fail --silent --show-error --location "$channel_url/git-revision")"
remote_page="$(curl --fail --silent --show-error --location "$channel_url")"

remote_version="unknown"
release_name="${channel_name#nixos-}"
release_regex="${release_name//./\\.}"
if [[ "$remote_page" =~ nixos-${release_regex}\.([0-9]+)\.([0-9a-f]{7,40}) ]]; then
    remote_version="${release_name}.${BASH_REMATCH[1]}.${BASH_REMATCH[2]}"
elif [[ "$remote_page" =~ nixos-([0-9]+\.[0-9]+\.[0-9]+\.[0-9a-f]{7,40}) ]]; then
    remote_version="${BASH_REMATCH[1]}"
fi

remote_semver=""
remote_version_hash=""
IFS=$'\t' read -r remote_semver remote_version_hash < <(split_nixos_version "$remote_version")
if [[ "$remote_version_hash" == "unknown" ]]; then
    remote_version_hash="$(short_hash "$remote_revision")"
fi

last_channel_update_epoch="$(stat -c %Y "$root_channels")"
last_rebuild_epoch="$(stat -c %Y "$system_profile")"
last_reboot_epoch="$(boot_time_epoch)"
IFS=$'\t' read -r first_generation generation_count fallback_install_epoch < <(first_generation_info)
install_epoch=""
install_source=""
if install_epoch="$(installation_epoch_from_file 2>/dev/null)"; then
    install_source="from os_installation_date"
else
    install_epoch="$fallback_install_epoch"
    if create_install_date_file "$fallback_install_epoch" 2>/dev/null; then
        install_source="created os_installation_date from generation $first_generation"
    else
        install_source="fallback from oldest retained generation $first_generation"
    fi
fi
current_generation="$(current_generation_number)"

current_system_path="$(readlink -f "$current_system")"
booted_system_path="$(readlink -f "$booted_system" 2>/dev/null || true)"
reboot_status="No reboot needed"
if [[ -n "$booted_system_path" && "$current_system_path" != "$booted_system_path" ]]; then
    reboot_status="Reboot pending"
elif [[ -z "$booted_system_path" ]]; then
    reboot_status="Unknown"
fi

running_kernel="$(uname -r)"
current_kernel_path="$(readlink -f "$current_system/kernel" 2>/dev/null || true)"
current_kernel="unknown"
if [[ -n "$current_kernel_path" ]]; then
    current_kernel_dir="${current_kernel_path%/*}"
    current_kernel_base="${current_kernel_dir##*/}"
    current_kernel="${current_kernel_base#*-linux-}"
fi

nvidia_info="not detected"
if command -v nvidia-smi >/dev/null 2>&1; then
    nvidia_info="$(nvidia-smi --query-gpu=driver_version,name --format=csv,noheader 2>/dev/null | paste -sd '; ' - || true)"
    if [[ -z "$nvidia_info" ]]; then
        nvidia_info="not detected"
    fi
fi

nix_version="$(nix --version 2>/dev/null || printf 'unknown')"

printf '\nSystem update check\n'
printf '%s\n' '=================='
printf 'This builds a candidate system from the remote channel and compares it with the active system.\n'
printf 'It does not update channels, switch generations, or modify /etc/nixos.\n\n'

{
    printf 'Metric\tValue\tWhen / Details\n'
    printf 'Time since last channel update\t%s\t%s\n' "$(format_age "$last_channel_update_epoch")" "$(format_date "$last_channel_update_epoch")"
    printf 'Time since last rebuild-switch\t%s\t%s\n' "$(format_age "$last_rebuild_epoch")" "$(format_date "$last_rebuild_epoch")"
    printf 'Time since last reboot\t%s\t%s\n' "$(format_age "$last_reboot_epoch")" "$(format_date "$last_reboot_epoch")"
    printf 'Time since OS installation\t%s\t%s (%s)\n' "$(format_age "$install_epoch")" "$(format_date "$install_epoch")" "$install_source"
    printf 'Current version\t%s\tshort hash %s\n' "$current_semver" "$(short_hash "$current_revision")"
    printf 'Current full hash\t%s\tfrom nixos-version --json\n' "$current_revision"
    printf 'Remote version\t%s\tshort hash %s\n' "$remote_semver" "$(short_hash "$remote_revision")"
    printf 'Remote full hash\t%s\t%s/git-revision\n' "$remote_revision" "$channel_url"
    printf 'Channel\t%s\t%s\n' "$channel_name" "$channel_url"
    printf 'Current generation\t%s\t%s\n' "$current_generation" "$current_system_path"
    printf 'Retained generations\t%s\toldest retained generation %s\n' "$generation_count" "$first_generation"
    printf 'Boot status\t%s\tbooted: %s\n' "$reboot_status" "${booted_system_path:-unknown}"
    printf 'Kernel\t%s running\t%s configured\n' "$running_kernel" "$current_kernel"
    printf 'NVIDIA\t%s\tGPU / driver\n' "$nvidia_info"
    printf 'Nix\t%s\tpackage manager\n' "$nix_version"
} | column -t -s $'\t'

printf '\nBuilding candidate system from %s...\n' "$channel_url"
build_log="$(mktemp -t check-system-update.XXXXXX.log)"
printf 'Build log: %s\n' "$build_log"

if ! candidate_system="$(
    NIX_PATH="nixpkgs=$channel_url/nixexprs.tar.xz:nixos-config=$nixos_config:$root_channels" \
        nix-build '<nixpkgs/nixos>' -A system --no-out-link 2>"$build_log"
)"; then
    printf 'Candidate system build failed. Full build log: %s\n' "$build_log" >&2
    exit 1
fi

printf 'Candidate system: %s\n\n' "$candidate_system"
printf 'nvd diff\n'
printf '%s\n' '========'
nvd diff "$current_system" "$candidate_system"
