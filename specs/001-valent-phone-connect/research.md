# Research: Install Valent for DMS Phone Connect

**Feature**: 001-valent-phone-connect
**Date**: 2026-03-23

## Decision: Valent Flatpak Source

**Decision**: Install Valent from the GNOME Nightly Flatpak repository, not Flathub main.

**Rationale**: `ca.andyholmes.Valent` is not yet available on the stable Flathub repository. The only Flatpak distribution is via the GNOME Nightly remote (`https://nightly.gnome.org/`). The `default-flatpaks` Blue Build module supports custom repo URLs, so this can be added as a separate configuration entry pointing to the nightly remote.

**Alternatives considered**:
- Wait for Valent to land on Flathub stable — deferred indefinitely; no release timeline.
- Install Valent via DNF — no COPR or Fedora package available at time of writing.
- Build Valent from source via cargo-builder stage — significant complexity; violates YAGNI.

---

## Decision: XDG Autostart

**Decision**: Ship a system-wide XDG autostart `.desktop` file at `/etc/xdg/autostart/ca.andyholmes.Valent.desktop` that launches the Flatpak on user login.

**Rationale**: Valent does not bundle its own XDG autostart entry. Without one, the app must be launched manually each session before DMS Phone Connect can detect it. Placing the file in `/etc/xdg/autostart/` (copied via the `files` module) applies it system-wide for all users with no per-user setup required.

**Alternatives considered**:
- Per-user autostart in `~/.config/autostart/` via tarion-sync — adds tarion-sync complexity; violates YAGNI.
- systemd user service — Flatpak apps are not reliably startable via systemd user units without additional D-Bus activation setup; XDG autostart is the simpler, standard path.

---

## Decision: Firewall Ports

**Decision**: No firewall configuration changes. Tarion does not ship a firewalld configuration.

**Rationale**: User confirmed Tarion has no firewalld setup. FR-003 (firewall ports) has been removed from scope. Users who need port access can configure firewalld manually.

---

## Key Facts

- **Flatpak App ID**: `ca.andyholmes.Valent`
- **Flatpak Remote URL**: `https://nightly.gnome.org/`
- **Remote Name**: `gnome-nightly` (conventional name for this remote)
- **Nightly GPG**: Available from `https://nightly.gnome.org/gnome-nightly.flatpakrepo`
- **DMS Phone Connect detection**: Automatic — DMS detects Valent via D-Bus when it is running.
- **Autostart mechanism**: XDG autostart `.desktop` file invoking `flatpak run ca.andyholmes.Valent`
