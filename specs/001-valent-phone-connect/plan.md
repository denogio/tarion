# Implementation Plan: Install Valent for DMS Phone Connect

**Branch**: `001-valent-phone-connect` | **Date**: 2026-03-23 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/001-valent-phone-connect/spec.md`

## Summary

Add Valent (`ca.andyholmes.Valent`) to Tarion's Flatpak installation list via the GNOME Nightly remote and ship a system-wide XDG autostart entry so Valent launches automatically at login, enabling DMS Phone Connect to detect and use it without any user setup.

## Technical Context

**Language/Version**: Bash (script snippets), YAML (Blue Build recipes)
**Primary Dependencies**: Blue Build `default-flatpaks` module, GNOME Nightly Flatpak remote
**Storage**: N/A
**Testing**: YAML syntax (`python3 -c "import yaml; ..."`), manual ISO test in QEMU
**Target Platform**: Fedora Atomic 43 / Universal Blue (immutable, rpm-ostree)
**Project Type**: Distribution configuration (recipe + static config files)
**Performance Goals**: Valent autostart completes before user reaches desktop
**Constraints**: No base-image mutation; all changes via recipe modules and `files/system/`

## Constitution Check

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Immutable by Default | ✅ Pass | All changes via Blue Build recipe modules and `files/` — no direct OS mutation |
| II. Zero-Tolerance Quality | ✅ Pass | No new shell scripts; YAML validated before commit |
| III. Always-Source Configuration | ✅ N/A | Flatpak install + autostart file; no user config sourcing needed |
| IV. Simplicity & YAGNI | ✅ Pass | Two targeted changes: one Flatpak entry, one `.desktop` file |
| V. Validation-First | ✅ Pass | YAML syntax check required before commit |

**Complexity Tracking**: No violations.

## Project Structure

### Documentation (this feature)

```text
specs/001-valent-phone-connect/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── quickstart.md        # Phase 1 output
└── tasks.md             # Phase 2 output (/speckit.tasks)
```

### Source Code (changes to repository)

```text
recipes/stages/
└── 03-apps.yml          # Add Valent to default-flatpaks system scope

files/system/etc/
└── xdg/
    └── autostart/
        └── ca.andyholmes.Valent.desktop   # XDG autostart entry (new file)
```

**Structure Decision**: Minimal delta — one YAML edit and one new static file. No new stages, scripts, or modules required.

## Phase 0: Research

See [research.md](research.md) for full findings. Key resolved decisions:

- **Flatpak source**: GNOME Nightly remote (`https://nightly.gnome.org/`) — Valent not on Flathub stable.
- **Flatpak ID**: `ca.andyholmes.Valent`
- **Autostart**: XDG autostart `.desktop` file required; Valent does not bundle one.
- **Firewall**: Out of scope — Tarion ships no firewalld configuration.
- **DMS integration**: Automatic — DMS Phone Connect detects Valent via D-Bus.

## Phase 1: Design

### Flatpak Installation

Add a new `default-flatpaks` configuration block in `recipes/stages/03-apps.yml` targeting the GNOME Nightly remote at system scope:

```yaml
- scope: system
  repo:
    title: GNOME Nightly
    url: https://nightly.gnome.org/gnome-nightly.flatpakrepo
  install:
    - ca.andyholmes.Valent
  notify: true
```

This installs Valent for all users on first boot, consistent with how Chromium and other system-scope Flatpaks are handled.

### XDG Autostart Entry

Create `files/system/etc/xdg/autostart/ca.andyholmes.Valent.desktop`:

```ini
[Desktop Entry]
Type=Application
Name=Valent
Comment=Phone integration for Tarion (DMS Phone Connect)
Exec=flatpak run ca.andyholmes.Valent
Icon=ca.andyholmes.Valent
X-GNOME-Autostart-enabled=true
NoDisplay=true
```

The `files` module in `05-config.yml` already copies `system/etc` → `/etc`, so this file is automatically included with no recipe changes needed.

### No Additional Recipe Changes

The `05-config.yml` `files` module already covers `system/etc` → `/etc`, so the autostart file is picked up automatically. No new module, stage, or script is required.
