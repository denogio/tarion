#!/usr/bin/env bash
# Tairon Package Manager - UI Helpers
# Fzf-based interactive selection with multi-select support
# Catppuccin-inspired for Tairon

set -euo pipefail

# Check if fzf is available
command -v fzf &>/dev/null || {
  gum style --foreground 196 "⚠️  fzf not installed!"
  echo ""
  echo "Install fzf to enable multi-select:"
  echo "  - brew install fzf"
  echo "  - Or via distro: sudo dnf install fzf"
  exit 1
}

# Fzf args for Tairon branding
# FZF_ARGS=(
#   --multi
#   --preview 'brew info {1}'
#   --preview-label="Tairon Package Info"
#   --preview-window="down:65%:wrap"
#   --preview-label-pos="bottom"
#   --bind 'alt-p:toggle-preview, alt-j/k: scroll, tab: multi-select'
#   --bind 'alt-d: preview-half-page-down, alt-u: preview-half-page-up'
#   --bind 'alt-k: preview-up, alt-j: preview-down'
#   --color="pointer:red,marker: red"
#   --height=40% # Make preview window larger for package info
# )

# Fzf args for multi-select in package removal
# FZF_REMOVE_ARGS=(
#   --multi
#   --preview 'brew info {1}'
#   --preview-label="Tairon Package Info"
#   --preview-window="down:65%:wrap"
#   --preview-label-pos="bottom"
#   --bind 'alt-p:toggle-preview'
#   --bind 'alt-d: preview-half-page-down, alt-u: preview-half-page-up'
#   --color="pointer:red,marker:red"
# )

# Multi-select package list (from installed)
# Source: .bashrc: export PATH for tairon commands
multi_select_packages() {
  local packages=$1
  local selected=()
  local fzf_args=(
    --multi
    --preview 'brew info {1}'
    --preview-label="Tairon Package Info"
    --preview-window="down:65%:wrap"
    --preview-label-pos="bottom"
    --bind 'alt-p:toggle-preview'
    --bind 'alt-d: preview-half-page-down, alt-u: preview-half-page-up'
    --color="pointer:red,marker:red"
  )

  # If no packages specified, list all from backend
  if [ -z "${packages}" ]; then
    packages=$(command -v brew list --formula | head -50)
  fi

  local selected
  selected=$(echo "${packages}" | fzf "${fzf_args[@]}" | tr -d '' -f2)

  if [[ -n "${selected}" ]]; then
    echo "${selected}"
  fi
}

# Fzf command runner (with gum styling)
fzf_run() {
  local cmd="$1"
  shift

  gum spin --spinner dots --title "Running..." -- "${cmd}"
  local exit_code=$?

  # Run fzf command and capture output
  local output
  output=$(eval "${cmd}" 2>/dev/null)
  exit_code=$?

  echo "${output}"
  return ${exit_code}
}
