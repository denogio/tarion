#!/usr/bin/env bash
# Tarion XDG Base Directory Helper
# Provides standardized paths for cache, config, state, and data directories
# Follows XDG Base Directory Specification: https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html

set -euo pipefail

# XDG Base Directory Specification defaults
: "${XDG_CACHE_HOME:="${HOME}/.cache"}"
: "${XDG_CONFIG_HOME:="${HOME}/.config"}"
: "${XDG_STATE_HOME:="${HOME}/.local/state"}"
: "${XDG_DATA_HOME:="${HOME}/.local/share"}"

# Tarion-specific directories
TARION_NAME="tarion"

# Get Tarion cache directory (user-specific non-essential data files)
# Usage: cache_dir=$(get_tarion_cache_dir)
# Returns: ~/.cache/tarion/
get_tarion_cache_dir() {
    echo "${XDG_CACHE_HOME}/${TARION_NAME}"
}

# Get Tarion config directory (user-specific configuration files)
# Usage: config_dir=$(get_tarion_config_dir)
# Returns: ~/.config/tarion/
get_tarion_config_dir() {
    echo "${XDG_CONFIG_HOME}/${TARION_NAME}"
}

# Get Tarion state directory (user-specific state files)
# Usage: state_dir=$(get_tarion_state_dir)
# Returns: ~/.local/state/tarion/
get_tarion_state_dir() {
    echo "${XDG_STATE_HOME}/${TARION_NAME}"
}

# Get Tarion data directory (user-specific data files)
# Usage: data_dir=$(get_tarion_data_dir)
# Returns: ~/.local/share/tarion/
get_tarion_data_dir() {
    echo "${XDG_DATA_HOME}/${TARION_NAME}"
}

# Ensure all directories exist with proper permissions
ensure_tarion_dirs() {
    local cache_dir config_dir state_dir data_dir
    
    cache_dir=$(get_tarion_cache_dir)
    config_dir=$(get_tarion_config_dir)
    state_dir=$(get_tarion_state_dir)
    data_dir=$(get_tarion_data_dir)
    
    mkdir -p "${cache_dir}"
    mkdir -p "${config_dir}"
    mkdir -p "${state_dir}"
    mkdir -p "${data_dir}"
    
    # Set appropriate permissions (user read/write, group/others none)
    chmod 700 "${cache_dir}" "${config_dir}" "${state_dir}" "${data_dir}" 2>/dev/null || true
}

# Get a specific file path in the appropriate XDG directory
# Usage: file_path=$(get_tarion_file "cache" "keybindings.cache")
#        file_path=$(get_tarion_file "state" "wallpaper-state")
#        file_path=$(get_tarion_file "data" "backups/latest.tar.gz")
get_tarion_file() {
    local type="$1"
    local filename="$2"
    
    case "${type}" in
        cache)
            echo "$(get_tarion_cache_dir)/${filename}"
            ;;
        config)
            echo "$(get_tarion_config_dir)/${filename}"
            ;;
        state)
            echo "$(get_tarion_state_dir)/${filename}"
            ;;
        data)
            echo "$(get_tarion_data_dir)/${filename}"
            ;;
        *)
            echo "Error: Invalid type '${type}'. Must be: cache, config, state, data" >&2
            return 1
            ;;
    esac
}

# Legacy compatibility functions (for backward compatibility during transition)
get_tarion_legacy_config_dir() {
    echo "${HOME}/.config/${TARION_NAME}"
}

get_tarion_legacy_cache_dir() {
    echo "${HOME}/.cache/${TARION_NAME}"
}

# Check if we should use legacy paths (for migration)
should_use_legacy_paths() {
    # If legacy directory exists but XDG directory doesn't, use legacy
    local legacy_config="${HOME}/.config/${TARION_NAME}"
    local xdg_config
    xdg_config=$(get_tarion_config_dir)
    
    if [[ -d "${legacy_config}" && ! -d "${xdg_config}" ]]; then
        return 0  # Use legacy
    fi
    return 1  # Use XDG
}