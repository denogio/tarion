#!/usr/bin/env bash
# Tairon Package Manager - Homebrew Backend
# Manages CLI tools and userland applications via Homebrew

set -euo pipefail

# Check if brew is available
if ! command -v brew &>/dev/null; then
  gum style --foreground 196 "⚠️  brew not available!"
  echo ""
  echo "Install Homebrew: https://docs.brew.sh"
  echo "Or: brew install via ublue-os tap"
  exit 1
fi

# List all installed packages
tairon_brew_list() {
  brew list --formula
}

# Search for packages
tairon_brew_search() {
  local query="$1"
  shift
  brew search "${query}"
}

# Get package info
tairon_brew_info() {
  # local package="$1"  # Currently unused, keeping for reference
  shift
  brew info "$@"
}

# Install packages
tairon_brew_install() {
  local packages=("$@")
  shift

  for pkg in "${packages[@]}"; do
    gum spin --spinner dots --title "Installing ${pkg}..." -- "brew install ${pkg}"
    if brew install "${pkg}" 2>/dev/null; then
      gum style --foreground "$(highlight_success)" "✓ ${pkg} installed"
    else
      gum style --foreground "$(highlight_error)" "✗ Failed to install ${pkg}"
    fi
  done
}

# Uninstall packages
tairon_brew_uninstall() {
  local packages=()
  local fzf_args=(
    --multi
    --preview 'brew info {1}'
    --preview-label="Tairon Package Info"
    --preview-window="down:65%:wrap"
    --preview-label-pos="bottom"
    --bind 'alt-p:toggle-preview'
    --bind 'alt-d: preview-half-page-down, alt-u: preview-half-page-up'
    --bind 'alt-k: preview-up, alt-j: preview-down'
    --color="pointer:red,marker:red"
  )

  # Show installed packages and let user select for removal
  gum style --foreground "$(get_accent)" "Select packages to uninstall:" ""

  # List all installed formulas (excluding core brew)
  local all_packages
  all_packages=$(brew list --formula | grep -v "^#" | fzf "${fzf_args[@]}")

  if [ -n "${all_packages}" ]; then
    # Remove selected packages
    gum spin --spinner dots --title "Removing packages..." -- "echo \"${all_packages}\" | tr '\n' ' ' | xargs brew uninstall -y"

    gum style --foreground "$(highlight_success)" "✓ Packages removed"
  else
    gum style --foreground "$(highlight_info)" "No packages selected - cancelled"
  fi
}

# Search packages (with fzf multi-select)
tairon_brew_search_fzf() {
  local query="$1"
  shift

  # Search with multi-select enabled
  local fzf_args=(
    --multi
    --preview "brew search --eval ${query}"
    --preview-label="Tairon Package Search"
    --preview-window="down:65%:wrap"
    --preview-label-pos="bottom"
    --bind 'alt-p:toggle-preview'
    --bind 'alt-d: preview-half-page-down, alt-u: preview-half-page-up'
    --color="pointer:red,marker:red"
  )

  local results
  results=$(brew search --eval "${query}" | fzf "${fzf_args[@]}")

  echo "${results}"
}

# Update all packages
tairon_brew_update() {
  gum spin --spinner dots --title "Updating Homebrew..." -- "brew update"
  gum style --foreground "$(highlight_success)" "✓ Homebrew updated"
}
