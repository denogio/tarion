# Tarion Development Guide

## Building the Image

### Prerequisites
- Podman or Docker
- Python 3.10+
- blue-build CLI

### Build Process

```bash
# Install blue-build
pip install blue-build

# Build image locally
blue-build build recipes/recipe.yml
```

### Build Stages

Tarion uses a multi-stage build:
1. **cargo-builder** - Builds Rust applications (bluetui, impala)
2. **Main build** - Applies all modules to Universal Blue base

### Module Structure

```
recipes/
├── recipe.yml                    # Main recipe
├── stages/
│   └── cargo-builder.yml         # Rust build stage
└── common/
    ├── sddm-modules.yml          # Display manager
    ├── common-modules.yml        # Core packages
    ├── hyprland-modules.yml      # Window manager
    ├── developer-tools.yml       # Dev tools (code, neovim)
    ├── cargo-binaries.yml        # Rust apps
    ├── extra-packages.yml        # Additional packages
    ├── proprietary-modules.yml   # Proprietary codecs
    └── final-modules.yml         # Cleanup
```

## Adding New Packages

### DNF Packages
Add to appropriate module in `recipes/common/`:

```yaml
- type: dnf
  install:
    packages:
      - package-name
```

### COPR Packages
Enable COPR repo and install:

```yaml
- type: dnf
  repos:
    copr:
      enable:
        - copr-name
  install:
    packages:
      - package-name
```

### Rust/Cargo Packages
1. Add to `recipes/stages/cargo-builder.yml`
2. Copy binary in `recipes/common/cargo-binaries.yml`

## Adding Configuration Files

Place files in `files/system/`:

```
files/system/
├── etc/                # System-wide config
├── usr/                # System-wide binaries
└── usr/lib/skel/       # User skeleton files
```

Use a `files` module in recipe:

```yaml
- type: files
  files:
    - source: system/etc/config
      destination: /etc/config
```

## Running Tests

```bash
# Check recipe syntax
python3 -c "import yaml; yaml.safe_load(open('recipes/recipe.yml'))"

# Check shell scripts
shellcheck files/scripts/*.sh

# Build test
blue-build build recipes/recipe.yml
```

## Releasing

1. Update version in `recipes/recipe.yml`
2. Update CHANGELOG.md
3. Push to main branch
4. GitHub Actions will build and publish image

## Continuous Integration

- **Build:** Runs on push, PR, daily at 06:00 UTC
- **Test:** Validates configs and scripts

## Issues & Support

Report issues: https://github.com/denogio/tarion/issues
Discussions: https://github.com/denogio/tarion/discussions
