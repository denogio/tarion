#!/usr/bin/env bash
set -euo pipefail

# Set up Vicinae for tarion
# This script is run during image build

# Ensure Vicinae config directory exists
mkdir -p /etc/vicinae

# Ensure Vicinae scripts directory exists
mkdir -p /usr/lib/vicinae/scripts

# Make scripts executable
chmod +x /usr/lib/vicinae/scripts/*

# Set up user script directory
mkdir -p /usr/lib/skel/.local/share/vicinae/scripts

echo "Vicinae setup complete!"
