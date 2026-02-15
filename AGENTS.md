# Tarion - Project Context for OpenCode

## Project Overview

**Tarion** is a developer-focused, immutable Fedora Atomic desktop distribution built with Universal Blue. It combines Hyprland (Wayland tiling WM), Vicinae launcher, and powerful developer tools to create a minimal, dark, productive desktop experience.

**Key Characteristics:**
- Immutable base (rpm-ostree) with seamless updates
- Always-Source configuration model for user customizations
- Developer-first with Homebrew-based CLI tools
- 13 curated themes with 14+ application integrations
- Zero-tolerance code quality (ShellCheck, pre-commit hooks)

## Tech Stack

### Core Technologies
- **Base**: Universal Blue / Fedora Atomic 43 (rpm-ostree)
- **Window Manager**: Hyprland with hyprscrolling layout plugin
- **Desktop Shell**: DankMaterialShell (DMS)
- **Launcher**: Vicinae (keyboard-driven, extensible)
- **Login Manager**: greetd + DMS-Greeter
- **Terminal**: Ghostty
- **Build System**: Blue Build (Python, YAML recipes)

### Development Tools
- **Languages**: Bash/shell scripts, YAML, Python (build scripts), Lua (Neovim)
- **Package Management**: Homebrew (CLI), Flatpak (desktop apps), DNF (system)
- **CLI Tools**: gum (styling), fzf (fuzzy selection), jq (JSON), ripgrep, fd, bat, eza, starship, lazygit, zoxide
- **Validation**: ShellCheck, Hyprland --verify-config, YAML syntax check
- **Testing**: QEMU VM for ISO testing, bwrap for sandboxed validation

## Code Quality Requirements

### Shell Scripts (CRITICAL)
**Zero-tolerance policy** - All scripts must pass ShellCheck with zero warnings/errors.

**Mandatory practices:**
```bash
#!/usr/bin/env bash          # Portable shebang
set -euo pipefail            # Strict error handling
```

**Pre-commit hooks** run automatically:
- `./scripts/lint-shell.sh` - Validates all .sh files
- `./scripts/validate-hyprland.sh` - Validates Hyprland configs

**ShellCheck configuration** (.shellcheckrc):
```bash
disable=SC1090,SC1091        # Can't follow non-constant source files
enable=add-default-case,deprecate-which,require-variable-braces
```

### YAML Recipes
- Follow blue-build v1 schema
- Use 2-space indentation
- Validate with: `python3 -c "import yaml; yaml.safe_load(open('recipes/recipe.yml'))"`

### Testing Before Committing
```bash
# Run all validations
just validate-config          # Validates Hyprland configs
./scripts/lint-shell.sh       # ShellCheck all scripts

# Check YAML syntax
python3 -c "import yaml; yaml.safe_load(open('recipes/recipe.yml'))"
```

## Development Workflow

### Available Commands (Justfile)
```bash
just                          # Show all commands
just iso                      # Build ISO for testing
just test-iso                 # Test ISO in QEMU VM
just validate-config          # Validate Hyprland configs
just update                   # Update system and Homebrew
just upgrade                  # Alias for update
```

### Typical Development Cycle
1. **Make changes** to configs, scripts, or recipes
2. **Run validations** (ShellCheck, Hyprland validation)
3. **Test locally**: Build and test ISO (optional)
4. **Commit** with conventional commits (feat:, fix:, docs:, etc.)
5. **Push** - GitHub Actions will:
   - Run ShellCheck on all scripts
   - Validate all configurations
   - Build container image
   - Push to ghcr.io/denogio/tarion

### Code Style Conventions
- **Shell scripts**: 4-space indentation, `set -euo pipefail`, portable shebangs
- **YAML files**: 2-space indentation, descriptive keys
- **Naming**:
  - Shell functions: `snake_case`, private functions prefixed with `_`
  - Variables: `UPPER_CASE` for constants, `lower_case` for locals
  - Modules: `descriptive-name.yml` (hyphenated)

## Project Structure

```
bluearchy/
├── recipes/                    # Blue-build recipes and modules
│   ├── recipe.yml             # Main recipe (defines image, stages, modules)
│   ├── stages/                # Build stages (cargo-builder.yml)
│   └── common/                # Runtime modules
│       ├── greetd-modules.yml
│       ├── common-modules.yml
│       ├── hyprland-modules.yml
│       ├── developer-tools.yml
│       ├── cargo-binaries.yml
│       ├── extra-packages.yml
│       └── final-modules.yml
├── files/                     # Files copied into image
│   ├── scripts/               # Build-time scripts
│   │   ├── addimageinfo.sh
│   │   ├── ensureautoupdates.sh
│   │   └── setupvicinae.sh
│   ├── system/                # System-wide files
│   │   ├── usr/share/tarion/
│   │   │   ├── defaults/      # Gold Standard system configs
│   │   │   └── themes/        # Tarion branding and 13 themes
│   │   └── usr/lib/
│   │       ├── tarion/        # Package manager (backends: brew, flatpak, dnf)
│   │       └── tarion-scripts/ # User utilities (wallpapers, themes)
│   └── etc/, systemd/         # System configuration
├── scripts/                   # Development utilities
│   ├── build-iso.sh
│   ├── lint-shell.sh
│   ├── test-iso.sh
│   └── validate-hyprland.sh
├── docs/                      # Documentation
│   ├── DEVELOPMENT.md
│   ├── CONFIGURATION.md
│   └── TROUBLESHOOTING.md
└── Justfile                   # Just commands
```

## Key Systems

### 1. Always-Source Configuration Model
User configs source system defaults, allowing seamless updates:

```
~/.config/hypr/hyprland.conf    →  sources  →  /usr/share/tarion/defaults/hypr/hyprland.conf
~/.config/dms/                   →  sources  →  /usr/share/tarion/defaults/dms/
```

**tarion-sync** runs at login to ensure sylinks are correct after updates:
```bash
tarion-sync --force             # Force sync from system defaults
```

**User customization workflow:**
1. System defaults in `/usr/share/tarion/defaults/` are authoritative
2. User configs in `~/.config/` source the defaults
3. Users can override by adding configurations outside sourced blocks
4. Updates never break user customizations

### 2. Theme System
**13 curated themes** with integration across 14+ applications:
- Hyprland (border colors, gaps, layout)
- DMS (widgets, bar, notifications)
- Vicinae (color scheme)
- Ghostty (terminal colors)
- GNOME (GTK, libadwaita)
- VSCode, Obsidian, Firefox, Discord, Spicetify, more...

**Theme structure:**
```
/usr/share/tarion/themes/
├── catppuccin-mocha/
│   ├── theme.sh              # Color definitions (get_accent, get_background, etc.)
│   ├── backgrounds/          # Theme wallpapers
│   ├── hyprland/             # Hyprland configs
│   ├── dms/                  # DMS configs
│   ├── vicinae/              # Vicinae theme
│   └── app-themes/           # Application-specific themes
```

**Theme switching:**
```bash
tarion-theme-set catppuccin-mocha    # Apply theme to all apps
tarion-theme-set-gnome catppuccin-mocha   # Apply to GNOME only
tarion-theme-set-vim catppuccin-mocha      # Apply to Vim/Neovim
```

### 3. Package Manager (tarion-pkg)
Multi-backend package management with unified UI:
- **Backends**: brew (CLI tools), flatpak (desktop apps), dnf (system packages)
- **UI**: fzf-based interactive multi-select
- **Consistent branding**: gum styling, colored output

**Usage:**
```bash
tarion-pkg install              # Interactive package selection
tarion-pkg install git ripgrep   # Install specific packages
tarion-pkg list                 # List installed packages
tarion-pkg search               # Search available packages
```

**Backend detection**: Automatically detects available backends and prompts user if multiple exist.

### 4. Wallpaper Switcher
Full-featured wallpaper management:
- 18 curated high-quality wallpapers (Unsplash)
- Random, sequential, and theme-based selection
- Sync to DMS-Greeter (login screen)
- CLI and Vicinae integration

**Commands:**
```bash
dms-wallpaper-switcher random          # Random wallpaper
dms-wallpaper-switcher next           # Next in sequence
dms-wallpaper-switcher from-theme     # Theme wallpaper
dms-wallpaper-switcher set <path>     # Specific wallpaper
dms-wallpaper-switcher sync-greeter   # Sync to login screen
```

### 5. Build System (Blue Build)
**Multi-stage build process:**

1. **cargo-builder stage**: Builds Rust binaries (bluetui, impala)
2. **Main build**: Applies modules in sequence

**Module types:**
- `dnf`: Package installation, repository configuration
- `systemd`: Service enable/disable/mask
- `script`: Execute shell scripts or inline snippets
- `files`: Copy files into image
- `containerfile`: Inject Containerfile instructions
- `copy`: Copy artifacts between stages
- `brew`: Homebrew integration

**Build locally:**
```bash
pip install blue-build
blue-build build recipes/recipe.yml
```

**Module order matters** (applied in sequence):
```
greetd → common → hyprland → developer-tools → cargo-binaries → extra → final
```

### 6. Testing and Validation
**Automated validations:**
- **ShellCheck**: All shell scripts (zero tolerance)
- **Hyprland validation**: All configs tested with `--verify-config` in bwrap sandbox
- **YAML syntax**: All recipes validated with Python yaml module
- **Pre-commit hooks**: Ensures quality before commits

**Manual testing:**
```bash
just iso                 # Build ISO
just test-iso            # Test in QEMU VM
just validate-config     # Validate Hyprland configs
./scripts/lint-shell.sh  # Run ShellCheck
```

**Validation scripts:**
- `scripts/validate-hyprland.sh`: Validates 13 theme configs + 4 main configs
- `scripts/lint-shell.sh`: Lints 30+ shell scripts
- YAML validation in GitHub Actions

## Common Patterns and Conventions

### Shell Script Patterns
**Error handling:**
```bash
command -v fzf &>/dev/null || {
  gum style --foreground 196 "⚠️  fzf not installed!"
  exit 1
}

if sudo bluebuild ...; then
  echo "✅ Success!"
else
  echo "❌ Failed!"
  exit 1
fi
```

**Dependency checks:**
```bash
for dep in gum fzf jq; do
  command -v $dep &>/dev/null || {
    echo "Missing: $dep" >&2
    exit 1
  }
done
```

**Color output (TTY-aware):**
```bash
source /usr/share/tarion/gum-theme.sh
gum style --foreground "$(highlight_error)" "Error message"
```

**Arrays:**
```bash
AVAILABLE_BACKENDS=("brew" "flatpak" "dnf")
for backend in "${AVAILABLE_BACKENDS[@]}"; do
  echo "Backend: $backend"
done
```

### YAML Recipe Patterns
**DNF modules:**
```yaml
- type: dnf
  install:
    packages:
      - hyprland
      - waybar
  repos:
    copr:
      enable:
        - lionheartp/Hyprland
```

**Systemd modules:**
```yaml
- type: systemd
  system:
    enabled:
      - greetd.service
    masked:
      - gnome-shell.service
  user:
    enabled:
      - vicinae.service
```

**Files modules:**
```yaml
- type: files
  files:
    - source: system/usr/share/tarion
      destination: /usr/share/tarion
```

**Script modules:**
```yaml
- type: script
  scripts:
    - addimageinfo.sh
    - ensureautoupdates.sh
  snippets:
    - 'echo "Build complete!"'
```

### Configuration Patterns
**Always-Source stub pattern:**
```bash
#!/usr/bin/env bash
set -euo pipefail

# === Managed: Sourced from system defaults ===
source /usr/share/tarion/defaults/hypr/hyprland.conf

# === User customizations ===
# Add your custom configurations here
```

**Theme color definitions:**
```bash
# theme.sh in each theme directory
COLOR_PRIMARY="#cba6f7"
COLOR_SECONDARY="#89b4fa"
COLOR_ACCENT="#f38ba8"

get_accent() { echo "$COLOR_ACCENT"; }
get_background() { echo "$COLOR_BACKGROUND"; }
```

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
```bash
tarion-sync --force  # Restore from system defaults
```

### Build errors
1. Check ShellCheck: `./scripts/lint-shell.sh`
2. Check YAML: `python3 -c "import yaml; yaml.safe_load(open('recipes/recipe.yml'))"`
3. Check Hyprland configs: `just validate-config`

### Package installation issues
```bash
tarion-pkg list              # Check installed packages
tarion-pkg install           # Re-run interactive install
```

## CI/CD

**GitHub Actions workflow:**
1. **ShellCheck**: Validates all shell scripts
2. **Tests**: YAML syntax, JSON configs, file existence
3. **Build**: Builds container image using blue-build
4. **Push**: Publishes to ghcr.io/denogio/tarion:latest

**Triggers:**
- Push to main branch
- Pull requests
- Daily at 06:00 UTC

## Important Notes

### Immutable System
- Base system (rpm-ostree) cannot be modified directly
- All changes in user space (`~/.config/`, `/usr/local/`)
- Rollback available: `rpm-ostree rollback`

### Always-Source Model
- Updates never overwrite user customizations
- User configs source system defaults
- `tarion-sync` maintains correct symlinks after updates

### Zero-Tolerance Quality
- No ShellCheck warnings allowed
- All configs must validate
- Pre-commit hooks enforce quality
- GitHub Actions block broken builds

### Development Environment
- Test in distrobox: `distrobox create -i fedora:41`
- ShellCheck in container: `distrobox enter -- sudo dnf install ShellCheck`
- Validate before committing: Run just commands and scripts

## File Locations

### Key Configuration Files
- **Hyprland**: `~/.config/hypr/hyprland.conf` → sources `/usr/share/tarion/defaults/hypr/hyprland.conf`
- **DMS**: `~/.config/dms/` → sources `/usr/share/tarion/defaults/dms/`
- **Vicinae**: `~/.config/vicinae/`
- **Ghostty**: `~/.config/ghostty/config`
- **Neovim**: `~/.config/nvim/init.lua`
- **Shell**: `~/.bashrc`

### System Files
- **Defaults**: `/usr/share/tarion/defaults/` (Gold Standard configs)
- **Themes**: `/usr/share/tarion/themes/` (13 themes)
- **Package Manager**: `/usr/lib/tarion/pkg/` (backends, core, UI)
- **User Scripts**: `/usr/lib/tarion-scripts/` (wallpapers, themes, utilities)

### Build Files
- **Main recipe**: `recipes/recipe.yml`
- **Modules**: `recipes/common/*.yml`
- **Stages**: `recipes/stages/*.yml`
- **Build scripts**: `files/scripts/*.sh`

## Contributing

1. All code must pass ShellCheck validation
2. Follow existing conventions and patterns
3. Test changes before committing
4. Use conventional commit messages (feat:, fix:, docs:, etc.)
5. Ensure pre-commit hooks pass

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## Resources

- **Documentation**: README.md, docs/DEVELOPMENT.md, docs/CONFIGURATION.md
- **Issues**: https://github.com/denogio/tarion/issues
- **Discussions**: https://github.com/denogio/tarion/discussions
- **Universal Blue**: https://universal-blue.org/
- **Blue Build**: https://blue-build.org/
