#!/usr/bin/env bash
# Setup default wallpapers for Tarion
# Downloads curated high-quality wallpapers to ~/Pictures/Wallpapers

set -euo pipefail

WALLPAPER_DIR="${HOME}/Pictures/Wallpapers"
SYSTEM_WALLPAPERS="/usr/share/backgrounds/tarion"

# Create wallpaper directory
mkdir -p "${WALLPAPER_DIR}"

# Define helper functions
download_wallpaper() {
    local name="$1"
    local url="$2"
    local output="${WALLPAPER_DIR}/${name}.jpg"

    if [ ! -f "${output}" ]; then
        echo "Downloading ${name}..."
        curl -L -o "${output}" "${url}" 2>/dev/null || {
            echo "Failed to download ${name}, skipping..."
            return 1
        }
    fi
}

copy_theme_wallpapers() {
    local theme_dir="${HOME}/.config/tarion/current/theme"
    local theme_backgrounds="${theme_dir}/backgrounds"

    if [ -d "${theme_backgrounds}" ]; then
        echo "Copying wallpapers from current theme..."
        cp -n "${theme_backgrounds}"/* "${WALLPAPER_DIR}/" 2>/dev/null || true
    fi
}

# Check if we already have wallpapers
if [ "$(find "${WALLPAPER_DIR}" -type f -name "*.jpg" -o -name "*.png" | wc -l)" -gt 5 ]; then
    echo "Wallpapers already set up (found existing wallpapers)"
    exit 0
fi

echo "Setting up default wallpapers..."

# Copy system-provided wallpapers if they exist
if [ -d "${SYSTEM_WALLPAPERS}" ]; then
    echo "Copying system wallpapers..."
    cp -n "${SYSTEM_WALLPAPERS}"/* "${WALLPAPER_DIR}/" 2>/dev/null || true
fi

# Copy wallpapers from current theme if available
copy_theme_wallpapers

# Download curated wallpapers from unsplash (high quality, free to use)
# Using specific photo IDs for consistent, beautiful wallpapers

# Curated collection of stunning wallpapers
# Abstract gradients and minimal designs

# ===========================
# Abstract Gradients (4)
# ===========================
# Purple/Blue gradient waves
download_wallpaper "abstract-gradient-purple" \
    "https://images.unsplash.com/photo-1557683316-973673baf926?w=3840&q=95"

# Minimal dark geometric
download_wallpaper "minimal-dark-geometric" \
    "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=3840&q=95"

# Aurora borealis inspired
download_wallpaper "aurora-abstract" \
    "https://images.unsplash.com/photo-1531366936337-7c912a4589a7?w=3840&q=95"

# Dark blue abstract
download_wallpaper "dark-blue-abstract" \
    "https://images.unsplash.com/photo-1558591710-4b4a1ae0f04d?w=3840&q=95"

# ===========================
# Neon & Cyberpunk (3)
# ===========================
# Neon grid cyberpunk
download_wallpaper "neon-grid-cyberpunk" \
    "https://images.unsplash.com/photo-1550745165-9bc0b252726f?w=3840&q=95"

# Cyberpunk city night
download_wallpaper "cyberpunk-city-night" \
    "https://images.unsplash.com/photo-1605806616949-1e87b487bc2a?w=3840&q=95"

# Neon purple waves
download_wallpaper "neon-purple-waves" \
    "https://images.unsplash.com/photo-1500462918059-b1a0cb512f1d?w=3840&q=95"

# ===========================
# Minimal Dark (4)
# ===========================
# Teal/cyan minimal
download_wallpaper "minimal-teal-waves" \
    "https://images.unsplash.com/photo-1579546929518-9e396f3cc809?w=3840&q=95"

# Dark geometric patterns
download_wallpaper "dark-geometric-patterns" \
    "https://images.unsplash.com/photo-1509248961158-e54f6934749c?w=3840&q=95"

# Minimalist dark texture
download_wallpaper "minimalist-dark-texture" \
    "https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=3840&q=95"

# Dark smooth gradient
download_wallpaper "dark-smooth-gradient" \
    "https://images.unsplash.com/photo-1550684848-fac1c5b4e853?w=3840&q=95"

# ===========================
# Landscapes & Nature (4)
# ===========================
# Mountain landscape sunset
download_wallpaper "mountain-sunset-gradient" \
    "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=3840&q=95"

# Mountain peaks with fog
download_wallpaper "mountain-peaks-fog" \
    "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=3840&q=95"

# Ocean waves at sunset
download_wallpaper "ocean-waves-sunset" \
    "https://images.unsplash.com/photo-1505142468610-359e7d316be0?w=3840&q=95"

# Forest mist
download_wallpaper "forest-mist-dawn" \
    "https://images.unsplash.com/photo-1448375240586-dfd8d395ea6c?w=3840&q=95"

# ===========================
# Space & Sky (3)
# ===========================
# Galaxy nebula
download_wallpaper "galaxy-nebula-deep" \
    "https://images.unsplash.com/photo-1462331940025-496dfbfc7564?w=3840&q=95"

# Starry night sky
download_wallpaper "starry-night-sky" \
    "https://images.unsplash.com/photo-1419242902214-272b3f66ee7a?w=3840&q=95"

# Northern lights
download_wallpaper "northern-lights-display" \
    "https://images.unsplash.com/photo-1531366936337-7c912a4589a7?w=3840&q=95"

echo "✓ Default wallpapers set up in ${WALLPAPER_DIR}"
echo "  Use 'tarion-wallpaper-switcher' or the wallpaper picker to select one"
echo ""
echo "Available commands:"
echo "  tarion-wallpaper-switcher random    - Select a random wallpaper"
echo "  tarion-wallpaper-switcher next      - Cycle to next wallpaper"
echo "  tarion-wallpaper-switcher prev      - Cycle to previous wallpaper"
echo "  tarion-wallpaper-switcher list      - List all wallpapers"
echo "  tarion-wallpaper-switcher set <file>- Set specific wallpaper"
