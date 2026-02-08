# Tarion Configuration System

This directory contains system-default configurations for Tarion.

## How it works

Tarion uses a two-layer configuration system:

1. **System Defaults** (`/usr/share/tarion/defaults/`)
   - Base configurations that ship with Tarion
   - Users should NOT modify these files
   - System updates can override these without affecting user configs

2. **User Overrides** (`/usr/share/tarion/themes/`)
   - User-specific customizations
   - These override system defaults
   - Users have full control over their environment

## Configuration Files

### Hyprland
- **System default**: `/usr/share/tarion/defaults/hyprland.conf`
- **User config**: `/usr/share/tarion/themes/hyprland.conf`
- **Behavior**: User config sources system default, then applies overrides

### Waybar
- **System default**: `/usr/share/tarion/defaults/waybar.conf`
- **User config**: `/usr/share/tarion/themes/waybar/config.jsonc`
- **Behavior**: Waybar loads both configs

## Philosophy

This follows the "user first" philosophy:
- System defaults provide a working out-of-the-box experience
- User configs allow complete customization
- Updates never break user customizations
- Easy to reset by deleting user config files

## Examples

### User-specific override

In `/usr/share/tarion/themes/hyprland.conf`:

```bash
# Source system defaults first
source /usr/share/tarion/defaults/hyprland.conf

# Then add custom overrides
$mod = SUPER

# Custom keybindings that override defaults
bind = $mod, A, exec, your-app

# Custom workspace rules
workspace = w[1-10]:1, monitor:eDP-1, default:true
```

### Resetting to defaults

```bash
# Remove user config to reset to defaults
rm /usr/share/tarion/themes/hyprland.conf
rm -rf /usr/share/tarion/themes/

# Next login will use system defaults
```

## Migration from Tarion/Tarion

If coming from Tarion or Tarion:
1. Copy your configs from `/usr/share/tarion/themes/` or `/usr/share/tarion/themes/`
2. Paste them into `/usr/share/tarion/themes/`
3. The configs will override system defaults
4. All Tarion scripts will use your customized configs

## Script Integration

Tarion scripts automatically check for user configs:
- `tarion-menu` - Uses both system and user configs
- `tarion-launch-*` - Respects user preferences
- `tarion-setup` - Creates initial user config from system defaults

## Supported Apps

These apps use the Tarion config system:
- Hyprland (window manager)
- Waybar (status bar)
- Mako (notifications)
- Vicinae (launcher)
- Ghostty (terminal)
- Neovim (editor)
