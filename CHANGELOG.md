# Changelog

All notable changes to Tairon will be documented in this file.

## [Unreleased]

### Added
- Initial release as Tairon (renamed from Bluearchy)
- Full Vicinae integration with custom configuration
- Developer tools: ripgrep, fd, bat, eza, starship, lazygit, zoxide (via Homebrew, managed by blue-build)
- Vicinae dmenu system controls (power, display, network, system info)
- JetBrains Mono fonts (already included)
- Enhanced justfile with developer commands
- Neovim configuration for developers
- Ghostty terminal configuration
- Tairon first-boot setup wizard (using gum for beautiful UX)
- Backup and restore utilities (using gum)
- Gum package for pretty CLI experience
- Hyprshot configuration
- Enhanced Mako notification config
- Tairon ASCII logo

### Changed
- Renamed from Bluearchy to Tairon
- Updated container registry to ghcr.io/denogio/tairon
- Homebrew installation now handled by blue-build (removed manual installation)
- Enhanced Vicinae configuration with developer-focused settings
- Improved Waybar styling
- Better error handling in setup scripts
- All user-facing scripts now use gum for better UX

### Fixed
- Fixed typo in branding script (bluerachy → tairon)
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
