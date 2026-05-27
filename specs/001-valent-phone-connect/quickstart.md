# Quickstart: Valent Phone Connect Development

**Feature**: 001-valent-phone-connect

## What Changes

| File | Change |
|------|--------|
| `recipes/stages/03-apps.yml` | Add GNOME Nightly remote + `ca.andyholmes.Valent` Flatpak |
| `files/system/etc/xdg/autostart/ca.andyholmes.Valent.desktop` | New XDG autostart entry |

## Validate Before Committing

```bash
# Check YAML syntax
python3 -c "import yaml; yaml.safe_load(open('recipes/stages/03-apps.yml'))"
python3 -c "import yaml; yaml.safe_load(open('recipes/recipe.yml'))"

# Run ShellCheck (no new scripts, but run anyway to catch regressions)
./scripts/lint-shell.sh

# Validate Hyprland configs (no changes expected, run for safety)
just validate-config
```

## Manual Testing (QEMU)

```bash
just iso        # Build the image
just test-iso   # Boot in QEMU VM
```

Inside the VM, verify:
1. `flatpak list | grep Valent` — Valent is installed
2. Valent appears in the running processes after login (autostart fired)
3. DMS Phone Connect is available and detects Valent

## Pairing Test

On your phone, install **KDE Connect** (Android/iOS). Ensure phone and desktop are on the same network. Open DMS Phone Connect — the phone should appear for pairing.
