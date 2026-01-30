#!/usr/bin/env bash
# Tairon Package Manager - Flatpak Backend
# Manages desktop applications via Flatpak

set -euo pipefail

# Check if flatpak is available
if ! command -v flatpak &>/dev/null; then
  gum style --foreground 196 "⚠️  flatpak not available!"
  echo ""
  echo "Install Flatpak: https://docs.flatpak.org/"
  echo "Or: sudo dnf install flatpak"
  exit 1
fi

# List all installed applications
tairon_flatpak_list() {
  flatpak list --app
}

# Search for applications
tairon_flatpak_search() {
  local query="$1"
  shift
  flatpak search "${query}"
}

# Get application info
tairon_flatpak_info() {
  local app_id="$1"
  shift
  flatpak info "${app_id}"
}

# Install applications
tairon_flatpak_install() {
  local apps=("$@")
  shift

  for app_id in "${apps[@]}"; do
    gum spin --spinner dots --title "Installing ${app_id}..." -- "flatpak install ${app_id} -y"

    if flatpak list --app | grep -q "^${app_id}" &>/dev/null; then
      gum style --foreground "$(highlight_success)" "✓ ${app_id} already installed"
    else
      if flatpak install "${app_id}" -y 2>/dev/null; then
        gum style --foreground "$(highlight_success)" "✓ ${app_id} installed"
      else
        gum style --foreground "$(highlight_error)" "✗ Failed to install ${app_id}"
      fi
    fi
  done
}

# Uninstall applications
tairon_flatpak_uninstall() {
  local fzf_args=(
    --multi
    --preview 'flatpak info {1}'
    --preview-label="Tairon App Info"
    --preview-window="down:65%:wrap"
    --preview-label-pos="bottom"
    --bind 'alt-p:toggle-preview'
    --bind 'alt-d: preview-half-page-down, alt-u: preview-half-page-up'
    --color="pointer:red,marker:red"
  )

  # List installed apps and let user select for removal
  gum style --foreground "$(get_accent)" "Select apps to uninstall:"

  local installed_apps
  installed_apps=$(flatpak list --app | fzf "${fzf_args[@]}")

  if [ -n "${installed_apps}" ]; then
    # Remove selected apps (multi-select)
    IFS=$'\n' read -r selected_apps
    for app in ${selected_apps}; do
      flatpak uninstall -y "${app}" 2>/dev/null || echo "Failed to uninstall: ${app}"
    done

    gum style --foreground "$(highlight_success)" "✓ Apps removed"
  else
    gum style --foreground "$(highlight_info)" "No apps selected - cancelled"
  fi
}

# Search applications (with multi-select)
tairon_flatpak_search_fzf() {
  gum style --foreground "$(get_accent)" "Search Flatpak apps:"

  local query="$1"
  shift

  # Search with multi-select enabled
  local fzf_args=(
    --multi
    --preview 'flatpak search {1}'
    --preview-label="Tairon Flatpak Search"
    --preview-window="down:65%:wrap"
    --preview-label-pos="bottom"
    --bind 'alt-p:toggle-preview'
    --bind 'alt-d: preview-half-page-down, alt-u: preview-half-page-up'
    --color="pointer:red,marker:red"
  )

  flatpak search "${query}" | fzf "${fzf_args[@]}"
}

# Update all applications
tairon_flatpak_update() {
  gum spin --spinner dots --title "Updating Flatpak..." -- "flatpak update -y"
  gum style --foreground "$(highlight_success)" "✓ Flatpak updated"
}
