# Changelog

All notable changes to Tarion will be documented in this file.

## [Unreleased]

### Added
- Tarion Wallpaper Switcher - comprehensive wallpaper management using DMS IPC
  - CLI tool: `tarion-wallpaper-switcher` with random, next, prev, get, list, set, from-theme commands
  - Uses DMS IPC calls for seamless wallpaper management (no external wallpaper tools required)
  - Vicinae integration via "Wallpaper Switcher" menu (SUPER+R)
    - DMS IPC library (`dms-ipc.sh`) for reusable DMS interaction functions
    - Direct DMS wallpaper switching with full metadata support
  - Keybindings: SUPER+W (random), SUPER+SHIFT+W (next), SUPER+ALT+W (previous)
  - DMS-greeter sync support with `sync-greeter` command
  - Wallpaper state management in `~/.config/tarion/wallpaper-state`
  - 18 curated Unsplash wallpapers (abstract gradients, dark minimal, cyberpunk, landscapes, space)
  - Automatic wallpaper copying from current theme
  - tarion-menu integration with hybrid menu structure
    - Quick wallpaper actions (random/next/prev) directly in Style menu
    - Full wallpaper submenu with advanced options
    - Support for random, next, previous, theme, select, refresh, sync, clear, get
    - Vicinae scripts documentation (`README.md` in Vicinae scripts directory)
- Initial release as Tarion (renamed from Bluearchy)
- Full Vicinae integration with custom configuration
- Developer tools: ripgrep, fd, bat, eza, starship, lazygit, zoxide (via Homebrew, managed by blue-build)
- Vicinae dmenu system controls (power, display, network, system info)
- JetBrains Mono fonts (already included)
- Enhanced justfile with developer commands
- Neovim configuration for developers
- Ghostty terminal configuration
- Tarion first-boot setup wizard (using gum for beautiful UX)
- Backup and restore utilities (using gum)
- Gum package for pretty CLI experience
- Hyprshot configuration
- Enhanced Mako notification config
- Tarion ASCII logo

### Changed
- Renamed from Bluearchy to Tarion
- Updated container registry to ghcr.io/denogio/tarion
- Homebrew installation now handled by blue-build (removed manual installation)
- Enhanced Vicinae configuration with developer-focused settings
- Improved Waybar styling
- Better error handling in setup scripts
- All user-facing scripts now use gum for better UX

### Fixed
- Fixed typo in branding script (bluerachy → tarion)
- Fixed YAML indentation issues in extra-packages.yml
- Removed unused rofi configuration

### Removed
- Omarchy launcher references (replaced with Vicinae)
- Legacy bluearchy references

---

## [0.1.0] - 2024-01-XX (Previous: Bluearchy)

Initial Bluearchy release:
- Universal Blue base with Fedora 43
- Hyprland window manager
- Waybar status bar
- Vicinae launcher (basic installation)
- SDDM with Maldives theme
- Auto-updates enabled
- Proprietary codecs via negativo17
- Developer tools: VS Code, Neovim, DevPod
