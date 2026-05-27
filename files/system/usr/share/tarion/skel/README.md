# Tarion Skeleton Configuration System

This directory (`/usr/share/tarion/skel/`) contains the **skeleton configurations** that are copied to user home directories on first login.

## How It Works

**Copy-on-First-Run** model (replaces the old always-source approach):

1. **Skeleton** (`/usr/share/tarion/skel/`) - Shipped with the image, never modified by user
2. **User Config** (`~/.config/`) - Copied from skeleton on first run, user has full control

### First Login
`tarion-sync` runs automatically at login and copies skeleton files to `~/.config/` if they don't exist.

### On System Updates
When the image updates, `tarion-sync` detects changed skeleton files and prompts the user:
- **[d]iff** - View differences
- **[o]verwrite** - Accept new default
- **[s]kip** - Keep user's version
- **[b]ackup+overwrite** - Save user version before accepting new default

## Directory Structure

```
skel/
├── hypr/              # Hyprland window manager configs
│   ├── bindings/      # Keybinding modules
│   └── apps/          # Per-application window rules
├── ghostty/           # Ghostty terminal config
├── niri/              # Niri window manager configs (config.kdl, bindings.kdl, autostart.kdl)
├── vicinae/           # Vicinae launcher settings
└── dms-plugins/       # DMS plugins
```

## Configuration Files

### Hyprland
Skeleton: `skel/hyprland.conf` + `skel/hypr/*.conf`
User copy: `~/.config/hypr/hyprland.conf` + `~/.config/hypr/*.conf`

### Niri
Skeleton: `skel/niri/config.kdl`, `skel/niri/bindings.kdl`, `skel/niri/autostart.kdl`
User copy: `~/.config/niri/config.kdl`, `~/.config/niri/bindings.kdl`, `~/.config/niri/autostart.kdl`

### Ghostty
Skeleton: `skel/ghostty/config`
User copy: `~/.config/ghostty/config`

## Manual Operations

```bash
# Force sync from skeleton (overwrites user files)
tarion-sync --force

# Show diff for a specific file
tarion-sync --diff ~/.config/hypr/hyprland.conf

# Reset a specific app to skeleton
rm -rf ~/.config/hypr
tarion-sync  # Will recopy on next login
```

## Design Philosophy

- **User control** - User configs are never overwritten without explicit consent
- **Immutable base** - System defaults are fixed in the image; user lives in home directory
- ** Seamless updates** - System updates don't break user customizations
- **Easy reset** - Delete user config, next login copies fresh from skeleton