# Tarion Package Manager

## Modular Package Management for Fedora Atomic

### Architecture

```
tarion-pkg              # Main entry point (tarion-pkg)
├── lib/
│   ├── core.sh       # Core loader and backend registration
│   └── ui.sh          # Fzf UI helpers
└── backends/
    ├── brew.sh         # Homebrew backend (CLI/userland tools)
    ├── flatpak.sh       # Flatpak backend (desktop applications)
    └── dnf.sh           # DNF backend (placeholder for future)
```

### Features

- **Multi-backend support**: Homebrew (CLI tools) + Flatpak (desktop apps)
- **Fzf-based UI**: Multi-select support (from Catppuccin inspiration)
- **Consistent Tarion branding**: All scripts use gum-theme.sh for beautiful colors
- **Auto-backend detection**: Automatically selects best backend for each action
- **Multi-select package management**: Install/uninstall multiple packages at once
- **Package search**: Search across available packages in current backend
- **Package info**: Show detailed package information

### Backends

| Backend | Purpose | Commands |
|---------|---------|----------|
| **brew** | CLI tools (ripgrep, nvim, etc.) | list, install, uninstall, search, info, update |
| **flatpak** | Desktop apps (Discord, Firefox, etc.) | list, install, uninstall, search, info, update |
| **dnf** | System packages (future) | Coming soon |

### Commands

```bash
# List packages (auto-detects best backend)
tarion-pkg list                    # All backends (brew + flatpak)
tarion-pkg list brew             # Homebrew packages only
tarion-pkg list flatpak           # Flatpak apps only
tarion-pkg list dnf              # Coming soon

# Install packages
tarion-pkg install nvim brew        # Install neovim via Homebrew
tarion-pkg install discord flatpak   # Install Discord via Flatpak

# Uninstall packages (multi-select)
tarion-pkg uninstall              # Select from all installed apps (brew + flatpak)
tarion-pkg uninstall ripgrep bat         # Select ripgrep and bat from brew
tarion-pkg uninstall flatpak discord   # Select and remove Discord via Flatpak

# Search packages
tarion-pkg search editor brew         # Search for editors in Homebrew
tarion-pkg search "fzf" brew         # fzf-based multi-select

# Package information
tarion-pkg info nvim brew            # Show neovim info via brew info
tarion-pkg info discord flatpak     # Show Discord info via flatpak info

# Update packages
tarion-pkg update brew              # Update all Homebrew packages
tarion-pkg update flatpak           # Update all Flatpak apps

# Options
tarion-pkg --backend <name>         - Force specific backend
tarion-pkg -m, --multi-select         - Enable multi-select for all commands
tarion-pkg -v, --version               - Show version and help
```

### Philosophy

1. **Immutable-first**: No system package writes (uses brew/flatpak only)
2. **User configs**: User customizations in `~/.config/tarion/pkg/`
3. **System defaults**: Base configurations in `/usr/share/tarion/defaults/`
4. **Modular design**: Each backend is self-contained and self-registering
5. **Consistent UX**: All commands use fzf + gum for beautiful interfaces
6. **Tarion branding**: Every component uses gum-theme.sh for colors

### For Fedora Atomic

- **Homebrew**: CLI and userland tools (ripgrep, nvim, starship, etc.)
- **Flatpak**: Desktop applications (Discord, Spotify, Firefox, etc.)
- **No DNF**: System packages not included (immutable)

### Inspiration

- Architecture from `.tarion/.inspiration/omarch-pkg*`
- Multi-select fzf from Catppuccin
- Modular design from your requirements
- Gum theming from Catppuccin (adapted for Tarion colors)
