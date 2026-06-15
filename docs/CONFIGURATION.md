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

## niri

### Location
- System defaults: `~/.local/share/tarion/niri/config.kdl` (synced from the image)
- User: `~/.config/niri/config.kdl` (includes the system defaults, add overrides below)

### Key Files
- `config.kdl` - Main configuration
- `bindings.kdl` - Keybindings
- `autostart.kdl` - Startup applications

### Reloading
niri reloads its configuration automatically whenever the file changes.

## DankMaterialShell (DMS)
DMS provides the top bar, widgets, and notification management.

### Location
- Config: `~/.config/dms/`

### Reloading
```bash
dms reload
```

## Scrollable Tiling (Layout)
niri provides a native scrollable-tiling layout similar to PaperWM — no plugin required.

### Configuration
Configured in the `layout { ... }` block of `~/.config/niri/config.kdl`.

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
- niri config
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
