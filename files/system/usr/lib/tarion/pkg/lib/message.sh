#!/usr/bin/env bash
# Tarion Package Manager - Message Helpers
# Consistent, styled messages for tarion-pkg and related tools
# Uses gum styling with Tarion theme colors

# Source theme colors
if [[ -f /usr/share/tarion/gum-theme.sh ]]; then
  source /usr/share/tarion/gum-theme.sh
fi

# Print success message
# Arguments:
#   $1 - Message to display
msg_success() {
  local message="${1}"
  gum style --foreground "$(highlight_success)" "✓ ${message}"
}

# Print error message
# Arguments:
#   $1 - Error message to display
msg_error() {
  local message="${1}"
  gum style --foreground "$(highlight_error)" "✗ ${message}"
}

# Print info message
# Arguments:
#   $1 - Info message to display
msg_info() {
  local message="${1}"
  gum style --foreground "$(highlight_info)" "ℹ ${message}"
}

# Print warning message
# Arguments:
#   $1 - Warning message to display
msg_warn() {
  local message="${1}"
  gum style --foreground "208" "⚠️  ${message}"
}

# Print section header
# Arguments:
#   $1 - Section title
msg_header() {
  local title="${1}"
  echo ""
  gum style --foreground "99" --bold "${title}"
}

# Print divider
msg_divider() {
  echo "─────────────────────────────────────────"
}
