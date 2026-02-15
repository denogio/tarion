# Package Management - Flatpak Bundles for Tarion

# Install productivity bundle
productivity:
  #!/usr/bin/env bash
  set -euo pipefail

  # Source Tarion theming if available
  if [ -f /usr/share/tarion/theme.sh ]; then
    source /usr/share/tarion/theme.sh
  fi

  echo ""
  gum style --foreground "${COLOR_PRIMARY:-212}" --border double --align center --margin "1 2" "Installing Productivity Bundle..."
  echo ""

  APPS=(
    "org.chromium.Chromium"      # Web browser (Tarion default)
    # Note: Chromium already in base image, so this will skip installation
    "com.github.IsmaelMartinez.thunderbird_for_linux"  # Email client
    "org.libreoffice.LibreOffice"  # Office suite
    "org.gnome.Evince"            # PDF viewer
    "org.gnome.Calculator"          # Calculator
  )

  for app in "${APPS[@]}"; do
    if ! flatpak list --app 2>/dev/null | grep -q "^${app}$"; then
      if command -v gum &>/dev/null; then
        gum spin --spinner dots --title "Installing ${app}..." -- flatpak install -y "${app}"
        gum style --foreground 46 "✓ ${app} installed"
      else
        echo "Installing ${app}..."
        flatpak install -y "${app}"
        echo "✓ ${app} installed"
      fi
    else
      if command -v gum &>/dev/null; then
        gum style --foreground 43 "⊘ ${app} already installed (from base image)"
      else
        echo "⊘ ${app} already installed (from base image)"
      fi
    fi
  done
