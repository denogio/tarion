# Tairon Configuration Guide

## Vicinae

### Location
- System: `/etc/vicinae/settings.json`
- User: `~/.config/vicinae/settings.json`

### Customization
To get default config:
```bash
vicinae config default
```

### Scripts
Location: `~/.local/share/vicinae/scripts`

See: https://docs.vicinae.com/scripts/getting-started

## Hyprland

### Location
- Default: `/usr/share/hyprland/hyprland.conf`
- User: `~/.config/hypr/hyprland.conf`

### Key Files
- `hyprland.conf` - Main configuration
- `hyprpaper.conf` - Wallpaper manager (if using)

### Reloading
```bash
hyprctl reload
```

## Waybar

### Location
- Config: `~/.config/waybar/config.jsonc`
- Style: `~/.config/waybar/style.css`

### Reloading
```bash
killall waybar
```

## Ghostty

### Location
- Config: `~/.config/ghostty/config`

### Themes
Built-in themes available, or create custom theme.

## Neovim

### Location
- Config: `~/.config/nvim/init.lua`

### Plugins
Managed with packer. Add to `init.lua`:
```lua
use 'plugin-author/plugin-name'
```

## Shell (bash)

### Location
- Aliases: `~/.bashrc`
- Starship config: `~/.config/starship.toml`

### Adding Aliases
Edit `~/.bashrc`:
```bash
alias mycommand='actual command'
```

## Mako (Notifications)

### Location
- Config: `~/.config/mako/config`

### Reloading
```bash
pkill mako && mako &
```

## System-wide Configuration

### GSettings Overrides
Location: `/usr/share/glib-2.0/schemas/zz1-tairon-theming.gschema.override`

To apply changes:
```bash
sudo glib-compile-schemas /usr/share/glib-2.0/schemas/
```

## First-Boot Setup

The setup wizard creates:
- `~/.config/tairon/setup-done` - Marks setup as complete

To re-run setup:
```bash
rm ~/.config/tairon/setup-done
tairon-setup
```

## Backup & Restore

### Backup
```bash
tairon-backup
```

Backs up:
- Hyprland config
- Waybar config
- Vicinae config
- Neovim config
- Ghostty config
- Shell aliases
- User applications

### Restore
```bash
tairon-restore ~/.config/tairon/backups/tairon-backup-YYYYMMDD_HHMMSS.tar.gz
```
