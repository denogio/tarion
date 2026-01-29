#!/usr/bin/env bash
#################################
# Script to customize gum CLI (https://github.com/charmbracelet/gum) with Tairon theme colors.
# Script will exchange signature gum pink for your favorite accent color.
#
# Based on Catppuccin theme colors for Tairon aesthetic
# Colors chosen to match Tairon branding:
#   - Primary: Deep purple (#7aa2f7)
#   - Secondary: Blue-green (#42a5f5)
#   - Accent: Red-orange (#f7768e)
#   - Neutral: Gray (#9ca0af)
#
# Author: holo96 (Davor Horvacki)
# Modified for Tairon by denogio
#
# Arguments:
# $1 - Catppuccin flavour (latte, frappe, macchiato, mocha) (optional, default: mocha)
# $2 - Accent color: primary color used for selected and cursor elements (optional, default: lavender)
# $3 - Highlight color: secondary color used for headers and emphasis (optional, default: complementary color)
#
# Usage:
# source gum-catppuccin.sh (inside .bashrc or .zshrc)
# gum confirm --foreground "$(get_accent_color)" "Continue?"
# gum choose -- "$(get_border_color)" "Choose option" --cursor "🎯"
#
#################################

GUM_THEME="${1:-mocha}"

# Validate flavour
if [[ ! "${GUM_THEME}" =~ ^(latte|frappe|macchiato|mocha)$ ]]; then
  echo "Invalid flavour: ${GUM_THEME}" >&2
  echo "Must be one of: latte, frappe, macchiato, mocha"
  return 1
fi

# GUM_ACCENT="${2:-lavender}"  # Currently unused, keeping for reference
# GUM_HIGHLIGHT="${3:-flamingo}"  # Currently unused, keeping for reference

# Catppuccin theme colors for Tairon
# These colors are inspired by Catppuccin but adapted for Tairon branding
# Primary: Deep purple (#7aa2f7) - Tairon's identity
# Secondary: Blue-green (#42a5f5) - Complementary accent
# Accent: Red-orange (#f7768e) - High visibility action color
# Neutral: Gray (#9ca0af) - Subtle UI elements

# Mocha color mappings
# Background: Dark (#1e1e2e)
# Surface 0: Darker (#181926)
# Surface 1: Lighter (#313244)
# Overlay 0: Light (#454757)
# Overlay 1: Lighter (#949c7b)
# Subtext 0: Subtle (#7a6c75)
# Subtext 1: Muted (#a6adc8)

# Tairon-specific colors
TAIRON_PRIMARY="#7aa2f7"  # Deep purple
TAIRON_SECONDARY="#42a5f5"  # Blue-green
TAIRON_ACCENT="#f7768e"  # Red-orange
TAIRON_NEUTRAL="#9ca0af"   # Gray

# Get theme color for gum (returns hex for Tairon accent)
get_tairon_accent() {
  echo "${TAIRON_ACCENT}"
}

# Get Tairon background color
get_tairon_background() {
  echo "${TAIRON_BG}"
}

# Get Tairon border color
get_tairon_border() {
  echo "${TAIRON_PRIMARY}"
}

# Highlight color for success/error/info
highlight_success() {
  echo "${TAIRON_SECONDARY}"
}

highlight_error() {
  echo "${TAIRON_ACCENT}"
}

highlight_info() {
  echo "${TAIRON_PRIMARY}"
}

# Print Tairon logo with Tairon theme
print_tairon_logo() {
  gum style \
    --foreground "${TAIRON_PRIMARY}" \
    --border double \
    --align center \
    --padding "1 2" \
    "$(cat /usr/share/tairon/logo.txt)"
}

# Set gum environment variables for Tairon theme
export GUM_STYLE_BORDER="${TAIRON_PRIMARY}"
export GUM_STYLE_FOREGROUND="${TAIRON_NEUTRAL}"
export GUM_STYLE_PROMPT="${TAIRON_PRIMARY}"
export GUM_STYLE_CURSOR="${TAIRON_ACCENT}"
export GUM_STYLE_HIGHLIGHT="${TAIRON_SECONDARY}"
