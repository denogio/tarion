<img width="957" height="208" alt="bluearchy-logo" src="https://github.com/user-attachments/assets/151be3c9-0241-4979-85cf-e82820855d35" />

[![bluebuild build badge](https://github.com/denogio/bluearchy/actions/workflows/build.yml/badge.svg)](https://github.com/denogio/bluearchy/actions/workflows/build.yml)

**Bluearchy** is not just a distro.
It is an **opinionated Universal Blue** fork, forged in the shadow of Omarchy’s vision.
It fuses **Hyprland**, Omarchy’s signature aesthetics, and **Vicinae** — replacing Omarchy’s launcher entirely for a faster, cleaner, and more modern experience.

Minimal. Dark. Relentless. Atomic.

---

## Installation

> [!WARNING]
> This is experimental territory. Proceed with caution.

Rebase an existing Fedora Atomic system to Bluearchy:

1. Rebase to the unsigned image first — this primes the system with the necessary keys and policies:

```
rpm-ostree rebase ostree-unverified-registry:ghcr.io/denogio/bluearchy:latest
```

2. Reboot into the new shadow:

```
systemctl reboot
```

3. Rebase to the signed image to lock in authenticity:

```
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/denogio/bluearchy:latest
```

4. Reboot once more to complete your transformation:

```
systemctl reboot
```

> The `latest` tag always points to the newest build, but the Fedora base remains anchored in `recipe.yml`.
> Progress without compromise.

---

## ISO

Generate an offline ISO from a Fedora Atomic system following
[Universal Blue instructions](https://blue-build.org/learn/universal-blue/#fresh-install-from-an-iso).

> ⚠️ GitHub cannot host these ISOs due to size. Public projects require external hosting.

---

## Vicinae Launcher

Bluearchy **replaces Omarchy’s launcher with Vicinae**.
This gives a **faster, cleaner, and more extensible experience** while keeping the minimalist, dark aesthetic intact.
Vicinae powers navigation, search, and workspace management with modern features Omarchy’s launcher lacks.

---

## Verification

All images are signed with [Sigstore](https://www.sigstore.dev/) via [cosign](https://github.com/sigstore/cosign).

Verify your build with:

```
cosign verify --key cosign.pub ghcr.io/denogio/bluearchy
```

---

### Description
> Opinionated Universal Blue distro, inspired by **Omarchy** — Hyprland, Omarchy aesthetics, and **Vicinae** (replacing Omarchy’s launcher) included.
> Minimal, dark, and unapologetically atomic.

---

Made with 🖤 by [denogio](https://github.com/denogio)
