# Tarion Skeleton Configuration System

This directory (`/usr/share/tarion/skel/`) holds the **skeleton configurations**
shipped with the image. They are the source of truth for system defaults and are
never edited by the user.

## How It Works

**Include model** (managed defaults + a small user-owned stub):

1. **Skeleton** (`/usr/share/tarion/skel/`) — shipped in the image, never modified.
2. **Local defaults** (`~/.local/share/tarion/`) — `tarion-sync` copies the skeleton
   here. This is the live copy that config files include. Refreshed on update.
3. **User config** (`~/.config/`) — for each *entry-point* file, `tarion-sync`
   creates a small stub that `include`s the matching default from
   `~/.local/share/tarion/`. The user owns this file and adds customizations
   *below* the include line.

Only entry-point files get a `~/.config` stub. Everything else is pulled in
transitively from `~/.local/share/tarion/` by an entry point and lives solely
there — e.g. `niri/config.kdl` includes `bindings.kdl`, `autostart.kdl` and
`dms/*.kdl`, so those have no `~/.config` stub of their own.

### First Login
`tarion-sync` runs automatically. It copies the skeleton into
`~/.local/share/tarion/` and creates the entry-point stub(s) in `~/.config/`
if they do not already exist.

### On System Updates
When the image ships new defaults, `tarion-sync` copies the changed files into
`~/.local/share/tarion/` (tracked by checksum). User stubs in `~/.config/` are
left untouched as long as they still contain the include line, so the new
defaults take effect without disturbing user customizations. If a `~/.config/`
entry-point file exists but is missing the include line, it is backed up
(`*.bak.<timestamp>`) before the stub is restored — never silently overwritten.

## Directory Structure

```
skel/
├── niri/              # niri configs — entry point: config.kdl
│                      #   (includes bindings.kdl, autostart.kdl, dms/*.kdl)
├── ghostty/           # Ghostty terminal config
├── vicinae/           # Vicinae launcher settings
└── dms-plugins/       # DMS plugins
```

## Configuration Files

### Niri (entry point: `config.kdl`)
- Skeleton: `skel/niri/config.kdl` (+ `bindings.kdl`, `autostart.kdl`, `dms/*.kdl`)
- Local default: `~/.local/share/tarion/niri/…` (full tree, refreshed on update)
- User stub: `~/.config/niri/config.kdl` — includes the local default; add your
  own settings below the include line. `niri` only reads `config.kdl`; the rest
  is reached through its includes, so there is intentionally no
  `~/.config/niri/bindings.kdl` or `autostart.kdl`.

> **Personal settings go in `~/.config/niri/config.kdl`, below the include line.**
> The files under `~/.local/share/tarion/niri/` (incl. `bindings.kdl`,
> `autostart.kdl`) are system defaults and are **overwritten on every update** —
> never edit them.
>
> - **New** binds / startup apps: add your own `binds { … }` / `spawn-at-startup`
>   in `config.kdl` after the include. Use key combos not already in the default
>   `bindings.kdl`.
> - **Changing an existing default key**: niri errors on duplicate keybinds, so you
>   cannot re-bind a default key from `config.kdl`. Either bind your action to a
>   different key, or change the default in the skeleton (`skel/niri/bindings.kdl`)
>   so the fix ships for everyone.

## Manual Operations

```bash
# Re-sync defaults into ~/.local/share/tarion and (re)create missing stubs
tarion-sync

# Force re-copy of all skeleton files into ~/.local/share/tarion
tarion-sync --force

# List which skeleton files changed since the last sync
tarion-sync --list

# Reset niri to defaults: drop your stub and re-sync
rm -f ~/.config/niri/config.kdl
tarion-sync
```

## Design Philosophy

- **User control** — entry-point stubs are not overwritten as long as the
  include line is intact; user edits below it are preserved.
- **Immutable base** — defaults are fixed in the image; the user lives in `$HOME`.
- **Seamless updates** — refreshed defaults flow through `~/.local/share/tarion/`
  without touching user stubs.
- **Easy reset** — delete the stub and re-run `tarion-sync`.
