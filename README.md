
                                      
                                             
                                     ▄▄▄ ▄▄ ▄▄ 
     ██              ▀▀               █  █ ▀ █ 
    ▀██▀▀ ▀▀█▄ ████▄ ██  ▄███▄ ████▄             
     ██  ▄█▀██ ██ ▀▀ ██  ██ ██ ██ ██             
     ██  ▀█▄██ ██    ██▄ ▀███▀ ██ ██             
                                             
                                             

[![bluebuild build badge](https://github.com/denogio/tarion/actions/workflows/build.yml/badge.svg)](https://github.com/denogio/tarion/actions/workflows/build.yml)

**Tarion** is a developer-focused, immutable Fedora Atomic distro built with Universal Blue.
It combines Hyprland, Vicinae launcher, and powerful developer tools to create a minimal,
dark, and unapologetically productive desktop experience.

Minimal. Dark. Developer-First. Atomic.

## Features

- **Hyprland** - Fast, dynamic tiling Wayland compositor
- **DankMaterialShell (DMS)** - Modern desktop shell providing widgets, top bar, and notification management
- **Greetd + DMS-Greeter** - Secure, integrated login manager and lock screen
- **Hyprscrolling** - Native scrolling layout plugin for Hyprland (PaperWM-style)
- **Vicinae** - Keyboard-driven launcher with plugins and dmenu support
- **Ghostty** - Modern terminal emulator
- **Developer Tools** - Homebrew-based installation of ripgrep, fd, bat, eza, starship, lazygit, zoxide
- **Auto-updates** - Seamless rpm-ostree updates
- **Immutable Base** - Fedora Atomic with Universal Blue

## Installation

> [!WARNING]
> This is experimental territory. Proceed with caution.

Rebase an existing Fedora Atomic system to Tarion:

1. Rebase to the unsigned image first:

```bash
rpm-ostree rebase ostree-unverified-registry:ghcr.io/denogio/tarion:latest
```

2. Reboot:

```bash
systemctl reboot
```

3. Rebase to the signed image:

```bash
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/denogio/tarion:latest
```

4. Reboot again:

```bash
systemctl reboot
```

> The `latest` tag always points to the newest build.

## First Setup

On first login, the Tarion setup wizard will guide you through:
- Installing developer tools (via Homebrew)
- Configuring Git
- Generating SSH keys
- Setting up wallpapers

You can also run the setup wizard manually:

```bash
tarion-setup
```

## Developer Tools

Tarion comes with a justfile for managing developer tools:

```bash
# Show all available commands
just

# Install all developer tools (ripgrep, fd, bat, eza, starship, lazygit, zoxide)
just dev-tools

# Configure developer tools (aliases, prompts)
just dev-setup

# Show installed tool versions
just dev-info

# Update all tools
just dev-update

# Clean up old versions
just dev-clean
```

## Vicinae Launcher

Tarion uses Vicinae as the primary launcher with extensive customizations:

### Key Features:
- **Application launcher** - SUPER+R
- **System controls menu** - SUPER+SHIFT+R (dmenu mode)
- **Window management** - Built-in support
- **Clipboard management** - Built-in support
- **Plugin system** - Extensible with community plugins

### System Controls:
- Power management (reboot, suspend, lock)
- Display settings (brightness, night mode)
- Network controls (WiFi, Bluetooth)
- System info (CPU, memory, temperature)
- System configuration

## Keybindings

### Hyprland:
- **SUPER+Enter** - Open terminal (Ghostty)
- **SUPER+E** - File manager (Thunar)
- **SUPER+Space** - Vicinae launcher
- **SUPER+SHIFT+R** - Vicinae system controls (dmenu)
- **CTRL+ALT+Space** - Vicinae window selection mode
- **SUPER+L** - Lock screen (DMS)
- **SUPER+Print** - Screenshot (region)
- **SUPER+SHIFT+Print** - Screenshot (full screen)
- **Arrow keys** - Navigate windows (scrolling layout)
- **SHIFT+Arrow keys** - Move windows
- **SUPER+, / SUPER+.** - Cycle window sizes (scrolling layout)
- **0-9** - Switch workspaces

### Vicinae:
- **Ctrl+P** - Search filter
- **Ctrl+,** - Open settings
- **Ctrl+B** - Toggle action panel
- **Ctrl+R** - Refresh

## Wallpaper Management

Set wallpapers using Vicinae:

1. Press SUPER+R to open Vicinae
2. Select "Wallpaper Picker"
3. Browse and select a wallpaper

Wallpapers should be placed in: `~/Pictures/Wallpapers/`

## Backups & Restore

Backup your Tarion configuration:

```bash
tarion-backup
```

Restore from backup:

```bash
tarion-restore <backup-file>
```

Backups are stored in: `~/.config/tarion/backups/`

## Updates

Update Tarion:

```bash
tarion-update
```

### Configuration Sync
Tarion uses an "Always-Source" model to keep your configurations up to date with the image. The `tarion-sync` tool runs automatically at login and ensures your local `~/.config` files point to the system-wide defaults in `/usr/share/tarion/defaults/`.

To manually ensure your local configurations are correctly linked to the system-wide defaults:

```bash
tarion-sync --force
```

Or manually:

```bash
rpm-ostree upgrade
systemctl reboot
```

Clean up old deployments:

```bash
tarion-clean
```

## ISO

Generate an offline ISO from a Fedora Atomic system following
[Universal Blue instructions](https://blue-build.org/learn/universal-blue/#fresh-install-from-an-iso).

> ⚠️ GitHub cannot host these ISOs due to size. Public projects require external hosting.

## Verification

All images are signed with [Sigstore](https://www.sigstore.dev/) via [cosign](https://github.com/sigstore/cosign).

Verify your build with:

```bash
cosign verify --key cosign.pub ghcr.io/denogio/tarion
```

## Configuration Files

Key configuration locations:
- **Hyprland:** `~/.config/hypr/hyprland.conf`
- **DMS:** `~/.config/dms/`
- **Vicinae:** `~/.config/vicinae/`
- **Ghostty:** `~/.config/ghostty/config`
- **Neovim:** `~/.config/nvim/init.lua`
- **Shell:** `~/.bashrc`

## Troubleshooting

### Vicinae not working
```bash
systemctl --user restart vicinae
```

### DMS not showing/responding
```bash
dms reload
```

### Reset Hyprland config
If you have messed up your configuration, you can force a sync from the system defaults:
```bash
tarion-sync --force
```
This will restore the "managed" stubs that source the system-wide configuration files while keeping your own additions if they are placed outside the managed blocks.

## Building Locally

Build Tarion locally using blue-build:

```bash
# Install blue-build
pip install blue-build

# Build image
blue-build build recipes/recipe.yml
```

## Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## Development

This project uses ShellCheck to ensure bash script quality and follows strict coding standards.

### Code Quality

**ShellCheck Integration:**
- All shell scripts are validated with ShellCheck
- Pre-commit hooks ensure quality before commits
- CI/CD pipeline validates code on pull requests
- Zero shellcheck warnings/errors are allowed

**Running ShellCheck Locally:**
```bash
# Install shellcheck in distrobox container
distrobox create -n shellcheck-dev -i registry.fedoraproject.org/fedora:41 --yes
distrobox enter shellcheck-dev -- sudo dnf install -y ShellCheck

# Run shellcheck on all scripts
bash scripts/lint-shell.sh
```

**Project Structure:**
- `files/system/usr/share/tarion/defaults/` - Gold Standard system configurations
- `files/system/usr/share/tarion/themes/` - Tarion branding and themes
- `files/system/usr/lib/tarion/pkg/` - Package manager system
- `files/system/usr/bin/` - Tarion system utilities (including `tarion-sync`)
- `files/scripts/` - System build-time setup and maintenance scripts
- `scripts/` - Development utilities and quality checks

### Contributing

When contributing to Tarion:
1. All shell scripts must pass ShellCheck validation
2. Follow existing code patterns and conventions
3. Test changes in a distrobox environment
4. Ensure pre-commit hooks pass before committing

**Setup Development Environment:**
```bash
# Install pre-commit hooks
pipx install pre-commit
pre-commit install

# Create shellcheck container
distrobox create -n shellcheck-dev -i registry.fedoraproject.org/fedora:41 --yes
distrobox enter shellcheck-dev -- sudo dnf install -y ShellCheck

# Test your changes
pre-commit run shellcheck --all-files
```

## License

Licensed under same license as Universal Blue (Apache License 2.0).

See [LICENSE](LICENSE) for details.

## Credits

Built with ❤️ using:
- [Universal Blue](https://universal-blue.org/)
- [Fedora Atomic](https://fedoraproject.org/atomic-desktops/)
- [Hyprland](https://hyprland.org/)
- [DankMaterialShell](https://github.com/avengemedia/dms) - Premium desktop shell
- [Hyprscrolling](https://github.com/hyprwm/contrib) - PaperWM-style window management
- [greetd](https://git.sr.ht/~kennylevinsen/greetd) - Login manager daemon
- [Vicinae](https://vicinae.com/)
- [Blue Build](https://blue-build.org/)
- [Wayblue](https://github.com/wayblueorg)

### Inspiration
Tarion is inspired by and partly based on [Omarchy](https://github.com/omarchy/omarchy). Many of the configuration patterns and architectural decisions are derived from their work in building a cohesive Hyprland experience on Fedora Atomic.

Made with 🖤 by [denogio](https://github.com/denogio)
