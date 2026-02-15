#!/usr/bin/env bash
# Tarion Package Manager - FZF Common Configurations
# Shared FZF arguments and preview commands for consistent UI

# Get default FZF arguments for package selection
# Returns: Array of FZF arguments (space-separated)
get_fzf_default_args() {
  echo \
    --multi \
    --preview-label="Tarion Package Info" \
    --preview-window="down:65%:wrap" \
    --preview-label-pos="bottom" \
    --bind 'alt-p:toggle-preview' \
    --bind 'alt-d:preview-half-page-down, alt-u:preview-half-page-up' \
    --color="pointer:red,marker:red" \
    --height=40%
}

# Get FZF arguments with custom preview command
# Arguments:
#   $1 - Preview command (e.g., 'brew info {1}', 'flatpak info {1}')
# Returns: Array of FZF arguments (space-separated)
get_fzf_args_with_preview() {
  local preview_cmd="${1}"
  echo \
    --multi \
    --preview "${preview_cmd}" \
    --preview-label="Tarion Package Info" \
    --preview-window="down:65%:wrap" \
    --preview-label-pos="bottom" \
    --bind 'alt-p:toggle-preview' \
    --bind 'alt-d:preview-half-page-down, alt-u:preview-half-page-up' \
    --color="pointer:red,marker:red" \
    --height=40%
}

# Get FZF arguments for removal (with preview)
# Returns: Array of FZF arguments (space-separated)
get_fzf_removal_args() {
  echo \
    --multi \
    --preview-label="Tarion Package Info" \
    --preview-window="down:65%:wrap" \
    --preview-label-pos="bottom" \
    --bind 'alt-p:toggle-preview' \
    --bind 'alt-d:preview-half-page-down, alt-u:preview-half-page-up' \
    --color="pointer:red,marker:red"
}

# Get preview command for Homebrew
# Returns: 'brew info {1}'
get_brew_preview_cmd() {
  echo 'brew info {1}'
}

# Get preview command for Flatpak
# Returns: 'flatpak info {1}'
get_flatpak_preview_cmd() {
  echo 'flatpak info {1}'
}

# Get preview command for DNF
# Returns: 'dnf info {1}'
get_dnf_preview_cmd() {
  echo 'dnf info {1}'
}
