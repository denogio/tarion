#!/usr/bin/env bash
# DMS IPC Library for Tarion
# Provides reusable functions for DMS interaction via IPC

set -euo pipefail

# Check if DMS is running
dms_check_running() {
    pgrep -x "dms" > /dev/null
    return $?
}

# Set wallpaper
dms_wallpaper_set() {
    local wallpaper_path="$1"
    
    if [ ! -f "${wallpaper_path}" ]; then
        echo "Error: Wallpaper not found: ${wallpaper_path}"
        return 1
    fi
    
    dms ipc call wallpaper set "${wallpaper_path}"
}

# Next wallpaper
dms_wallpaper_next() {
    dms ipc call wallpaper next
}

# Previous wallpaper
dms_wallpaper_prev() {
    dms ipc call wallpaper prev
}

# Get current wallpaper
dms_wallpaper_get_current() {
    dms ipc call wallpaper get 2>/dev/null
}

# Set random wallpaper from directory
dms_wallpaper_set_random() {
    local WALLPAPER_DIR="${HOME}/Pictures/Wallpapers"
    
    if [ ! -d "${WALLPAPER_DIR}" ]; then
        mkdir -p "${WALLPAPER_DIR}"
        echo "Wallpapers directory created"
        return 1
    fi
    
    declare -a wallpapers
    while IFS= read -r -d '' file; do
        wallpapers+=("${file}")
    done < <(find "${WALLPAPER_DIR}" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) -print0 | sort -z)
    
    if [ ${#wallpapers[@]} -eq 0 ]; then
        echo "Error: No wallpapers found"
        return 1
    fi
    
    local random_wallpaper="${wallpapers[${RANDOM} % ${#wallpapers[@]}]}"
    dms_wallpaper_set "${random_wallpaper}"
}

# Set wallpaper from current theme
dms_wallpaper_set_from_theme() {
    local theme_dir="${HOME}/.config/tarion/current/theme"
    local theme_backgrounds="${theme_dir}/backgrounds"
    
    if [ ! -d "${theme_backgrounds}" ]; then
        echo "Error: Theme backgrounds not found"
        return 1
    fi
    
    declare -a wallpapers
    while IFS= read -r -d '' file; do
        wallpapers+=("${file}")
    done < <(find "${theme_backgrounds}" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) -print0 | sort -z)
    
    if [ ${#wallpapers[@]} -eq 0 ]; then
        echo "Error: No theme wallpapers found"
        return 1
    fi
    
    local theme_wallpaper="${wallpapers[${RANDOM} % ${#wallpapers[@]}]}"
    dms_wallpaper_set "${theme_wallpaper}"
}

# Clear all wallpapers
dms_wallpaper_clear() {
    dms ipc call wallpaper clear
}

# Sync to DMS-greeter
dms_sync_greeter() {
    dms greeter sync
}

# Interactive wallpaper selection
dms_wallpaper_select_interactive() {
    local WALLPAPER_DIR="${HOME}/Pictures/Wallpapers"
    
    if [ ! -d "${WALLPAPER_DIR}" ]; then
        mkdir -p "${WALLPAPER_DIR}"
        echo "Wallpapers directory created"
        exit 0
    fi
    
    declare -a wallpapers
    while IFS= read -r -d '' file; do
        wallpapers+=("${file}")
    done < <(find "${WALLPAPER_DIR}" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) -print0 | sort -z)
    
    if [ ${#wallpapers[@]} -eq 0 ]; then
        echo "Error: No wallpapers found"
        return 1
    fi
    
    local wallpaper
    wallpaper=$(find "${WALLPAPER_DIR}" -type f | vicinae dmenu --placeholder "Select wallpaper...")
    
    if [ -n "${wallpaper}" ]; then
        dms_wallpaper_set "${wallpaper}"
    fi
}

# Refresh wallpaper list
dms_wallpaper_refresh_list() {
    local WALLPAPER_DIR="${HOME}/Pictures/Wallpapers"
    
    if [ ! -d "${WALLPAPER_DIR}" ]; then
        mkdir -p "${WALLPAPER_DIR}"
        echo "Wallpapers directory created"
        exit 0
    fi
    
    declare -a wallpapers
    while IFS= read -r -d '' file; do
        wallpapers+=("${file}")
    done < <(find "${WALLPAPER_DIR}" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) -print0 | sort -z)
    
    local count=${#wallpapers[@]}
    echo "Wallpaper list refreshed: ${count} wallpapers"
}
