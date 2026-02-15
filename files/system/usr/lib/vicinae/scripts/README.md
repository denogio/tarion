# Tarion Vicinae Scripts

This directory contains custom Vicinae scripts for Tarion, providing seamless integration between Vicinae launcher and system components.

## Available Scripts

### DMS Wallpaper Switcher
**File:** `wallpaper-switcher`
**Metadata:**
- Schema Version: 1
- Title: DMS Wallpaper Switcher
- Mode: dmenu
- Category: Style

**Description:**
Manage wallpapers using DMS IPC for seamless integration with DankMaterialShell.

**Features:**
- 🎲 Random Wallpaper - Set random wallpaper from directory
- ⏭️  Next Wallpaper - Cycle to next wallpaper
- ◀️  Previous Wallpaper - Cycle to previous wallpaper
- 🎨 Theme Wallpaper - Use random wallpaper from current theme
- 📋 Select Wallpaper - Interactive wallpaper selection
- 🔄 Refresh List - Refresh wallpaper directory
- 🔁 Sync to Greeter - Sync current wallpaper to DMS-greeter

**Usage:**
```bash
# Via Vicinae (SUPER+R)
vicinae vicinae://extensions/vicinae/scripts/wallpaper-switcher

# Direct execution
/usr/lib/vicinae/scripts/wallpaper-switcher
```

**Dependencies:**
- DMS (DankMaterialShell) must be running
- Vicinae launcher

**Wallpaper Locations:**
- User wallpapers: `~/Pictures/Wallpapers/`
- Theme wallpapers: `~/.config/tarion/current/theme/backgrounds/`

### System Controls
**File:** `system-controls`
**Metadata:**
- Schema Version: 1
- Title: System Controls
- Mode: dmenu

**Description:**
System controls menu for power management, display settings, network controls, and system information.

**Features:**
- ⏻ Power Off
- 🔄 Reboot
- 🔒 Lock Screen
- 💤 Suspend
- 🖥️ Display Settings
- 🌙 Night Mode
- 📺 Refresh Rate
- 📶 WiFi Toggle
- 🔵 Bluetooth Toggle
- 📊 System Info
- 💾 Disk Usage
- 🌡️ Temperature
- ⚡ CPU Info
- 📝 System Logs
- ⚙️ System Settings
- 🔧 System Config
- 🎯 Reload Hyprland
- 🔄 Restart Vicinae

**Usage:**
```bash
# Via Vicinae (SUPER+SHIFT+R)
vicinae vicinae://extensions/vicinae/scripts/system-controls

# Direct execution
/usr/lib/vicinae/scripts/system-controls
```

## Script Structure

Each script follows this structure:

```bash
#!/usr/bin/env bash
# @vicinae.schemaVersion 1
# @vicinae.title Script Title
# @vicinae.mode dmenu
# @vicinae.description Brief description
# @vicinae.category Category (optional)
# @vicinae.icon Icon name (optional)

set -euo pipefail

# Script code...

main() {
    # Main logic
}

main
```

## Vicinae Metadata

### Required Metadata
- `@vicinae.schemaVersion` - Always `1` for current Vicinae version
- `@vicinae.title` - Display name in Vicinae UI

### Optional Metadata
- `@vicinae.mode` - Execution mode (dmenu, default, etc.)
- `@vicinae.description` - Tooltip/help text
- `@vicinae.category` - Group scripts in Vicinae UI
- `@vicinae.icon` - Icon to display (Nerd Font emoji supported)

## DMS IPC Library

**File:** `dms-ipc.sh`
**Description:**
Reusable library of DMS IPC functions for use across Vicinae scripts.

**Available Functions:**
```bash
# Check if DMS is running
dms_check_running

# Wallpaper management
dms_wallpaper_set <path>              # Set specific wallpaper
dms_wallpaper_next                      # Next wallpaper
dms_wallpaper_prev                      # Previous wallpaper
dms_wallpaper_get_current             # Get current wallpaper path
dms_wallpaper_set_random              # Set random wallpaper
dms_wallpaper_set_from_theme          # Set from current theme
dms_wallpaper_clear                     # Clear all wallpapers

# Greeter sync
dms_sync_greeter                      # Sync to DMS-greeter
```

**Usage Example:**
```bash
#!/usr/bin/env bash
# @vicinae.schemaVersion 1
# @vicinae.title My DMS Script
# @vicinae.mode dmenu

# Source DMS IPC library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/dms-ipc.sh"

# Check DMS is running
if ! dms_check_running; then
    echo "DMS is not running"
    exit 1
fi

# Use DMS functions
dms_wallpaper_set_random
```

## Development

### Creating New Scripts

1. Create script file in this directory
2. Add proper Vicinae metadata
3. Implement logic using available libraries
4. Test with Vicinae: `vicinae vicinae://extensions/vicinae/scripts/<name>`
5. Make script executable: `chmod +x <script>`

### Testing Scripts

```bash
# Test script directly
./script-name

# Test via Vicinae
vicinae vicinae://extensions/vicinae/scripts/script-name

# Debug mode (add to script)
set -x  # Enable bash debug output
```

## Integration Points

### tarion-menu
- Style → Wallpaper (Quick) - Quick wallpaper actions
- Style → Wallpaper (Menu) - Full wallpaper menu

### Keybindings (Hyprland)
- `SUPER+W` - Random wallpaper (via tarion-wallpaper-switcher)
- `SUPER+SHIFT+W` - Next wallpaper (via tarion-wallpaper-switcher)
- `SUPER+ALT+W` - Previous wallpaper (via tarion-wallpaper-switcher)

## Resources

- [Vicinae Documentation](https://docs.vicinae.com)
- [DMS Documentation](https://danklinux.com/docs/dankmaterialshell)
- [DMS Wallpaper IPC](https://danklinux.com/docs/dankmaterialshell/cli-dank16#wallpaper)
- [DMS IPC](https://danklinux.com/docs/dankmaterialshell/keybinds-ipc)
- [Tarion Documentation](../README.md)

## Troubleshooting

### Script not showing in Vicinae
1. Check script has proper metadata: `@vicinae.schemaVersion 1`, `@vicinae.title`
2. Ensure script is executable: `chmod +x <script>`
3. Restart Vicinae: `systemctl --user restart vicinae`
4. Check Vicinae logs: `journalctl --user -u vicinae -f`

### DMS IPC commands failing
1. Ensure DMS is running: `pgrep -x dms`
2. Check DMS version compatibility (requires DMS 1.0+)
3. Verify wallpaper file paths are correct
4. Check DMS logs for IPC errors

### Notification issues
1. Ensure notify-send is installed
2. Check notification daemon is running
3. Test notifications: `notify-send "Test" "Test message"`

## Contributing

When adding new scripts:
1. Follow existing code style
2. Add proper error handling
3. Include Vicinae metadata
4. Document usage in this README
5. Test thoroughly before committing
