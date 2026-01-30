#!/usr/bin/env bash
# Tairon Package Manager Core Loader
# Loads all available backends dynamically
# Supports: brew (Homebrew), flatpak, dnf (future)

set -euo pipefail

# SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"  # Currently unused, keeping for reference
# PKG_ROOT="$(dirname "${SCRIPT_DIR}")"  # Currently unused, keeping for reference
# LIB_DIR="${SCRIPT_DIR}"  # Currently unused, keeping for reference
# BACKENDS_DIR="${PKG_ROOT}/backends"  # Currently unused, keeping for reference

# Source Tairon branding
source /usr/share/tairon/theme.sh

# Available backends
AVAILABLE_BACKENDS=("brew" "flatpak" "dnf")
INSTALLED_BACKENDS=()

# Backend registration functions
_register_backend_brew() {
  INSTALLED_BACKENDS+=("brew")
}

_register_backend_flatpak() {
  INSTALLED_BACKENDS+=("flatpak")
}

_register_backend_dnf() {
  INSTALLED_BACKENDS+=("dnf")
}

# Check and register backends
check_and_register_backends() {
  INSTALLED_BACKENDS=()

  if command -v brew &>/dev/null; then
    AVAILABLE_BACKENDS+=("brew")
    INSTALLED_BACKENDS+=("brew")
    _register_backend_brew
  else
    echo "Warning: brew not available (will skip)" >&2
  fi

  if command -v flatpak &>/dev/null; then
    AVAILABLE_BACKENDS+=("flatpak")
    INSTALLED_BACKENDS+=("flatpak")
    _register_backend_flatpak
  else
    echo "Warning: flatpak not available (will skip)" >&2
  fi

  # dnf (future - just marked as available)
  AVAILABLE_BACKENDS+=("dnf")
}

# Get installed backends
get_installed_backends() {
  echo "${INSTALLED_BACKENDS[@]}"
}

# Get available backends
get_available_backends() {
  echo "${AVAILABLE_BACKENDS[@]}"
}

# Validate backend exists
backend_exists() {
  local backend="$1"
  for installed_backend in "${INSTALLED_BACKENDS[@]}"; do
    [[ "${installed_backend}" == "${backend}" ]] && return 0
  done
  return 1
}

# Get backend info
get_backend_info() {
  local backend="$1"
  case "${backend}" in
    brew)
      echo "Package manager for CLI and userland tools"
      ;;
    flatpak)
      echo "Package manager for desktop applications"
      ;;
    dnf)
      echo "System package manager (future)"
      ;;
    *)
      echo "Unknown backend: ${backend}" >&2
      return 1
      ;;
  esac
}

# Auto-detect backend for action
detect_backend_for_action() {
  local action="$1"

  case "${action}" in
    install|uninstall|search|update)
      # Prefer flatpak or brew based on what's available
      if backend_exists "flatpak" || [[ "$1" == "flatpak" ]]; then
        echo "flatpak"
      elif backend_exists "brew" || [[ "$1" == "brew" ]]; then
        echo "brew"
      else
        echo "error"
        return 1
      fi
      ;;
    list|info)
      # Show all backends or installed only
      echo "all"
      ;;
    *)
      echo "error"
      return 1
      ;;
  esac
}
