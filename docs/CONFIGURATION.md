# Tarion Configuration Guide

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

## DankMaterialShell (DMS)
DMS provides the top bar, widgets, and notification management.

### Location
- Config: `~/.config/dms/`

### Reloading
```bash
dms reload
```

## Hyprscrolling (Layout)
Tarion uses a scrolling layout similar to PaperWM.

### Configuration
Located in `/usr/share/tarion/defaults/hypr/looknfeel.conf`.

### Common Dispatchers
- `scroller:movefocus`: Navigate columns
- `scroller:movewindow`: Move columns/windows
- `scroller:cyclesize`: Change column width

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

## System-wide Configuration

### GSettings Overrides
Location: `/usr/share/glib-2.0/schemas/zz1-tarion-theming.gschema.override`

To apply changes:
```bash
sudo glib-compile-schemas /usr/share/glib-2.0/schemas/
```

## First-Boot Setup

The setup wizard creates:
- `~/.config/tarion/setup-done` - Marks setup as complete

To re-run setup:
```bash
rm ~/.config/tarion/setup-done
tarion-setup
```

## Backup & Restore

### Backup
```bash
tarion-backup
```

Backs up:
- Hyprland config
- DMS config
- Vicinae config
- Neovim config
- Ghostty config
- Shell aliases
- User applications

### Restore
```bash
tarion-restore ~/.config/tarion/backups/tarion-backup-YYYYMMDD_HHMMSS.tar.gz
```
