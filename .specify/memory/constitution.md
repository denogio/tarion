<!--
SYNC IMPACT REPORT
==================
Version change: [template] → 1.0.0 (initial ratification)

Modified principles: N/A (first fill)

Added sections:
- Core Principles (5 principles derived from project context)
- Technology Stack & Constraints
- Development Workflow & Quality Gates
- Governance

Removed sections: N/A

Templates requiring updates:
- .specify/templates/plan-template.md ✅ Constitution Check section already present;
  gates are generic and work with these principles — no update required.
- .specify/templates/spec-template.md ✅ User story + requirements structure aligns
  with Always-Source and Zero-Tolerance principles — no update required.
- .specify/templates/tasks-template.md ✅ Phase structure and ShellCheck/validation
  tasks align with Validation-First principle — no update required.
- .specify/templates/agent-file-template.md ✅ Generic template; no constitution
  references to update.

Follow-up TODOs:
- None. All placeholders resolved.
-->

# Tarion Constitution

## Core Principles

### I. Immutable by Default

The system base MUST remain immutable (rpm-ostree). No feature, script, or
workflow may mutate the running OS layer directly. All runtime customizations
MUST live in user-space (`~/.config/`) or overlay directories. Changes to the
image MUST be expressed as declarative recipe modules and rebuilt via the
Blue Build pipeline.

**Rationale**: Immutability guarantees reproducible installs, safe atomic
rollbacks (`rpm-ostree rollback`), and prevents configuration drift between
machines.

### II. Zero-Tolerance Quality

Every shell script MUST pass ShellCheck with **zero warnings and zero errors**.
Every Hyprland configuration MUST pass `--verify-config` validation. Every YAML
recipe MUST parse cleanly with the Python `yaml` module. No exceptions.

Mandatory script boilerplate:
```bash
#!/usr/bin/env bash
set -euo pipefail
```

Pre-commit hooks (`lint-shell.sh`, `validate-hyprland.sh`) MUST not be skipped
(`--no-verify` is forbidden unless the user explicitly requests it).

**Rationale**: A single ShellCheck warning allowed becomes ten; ten become
broken prod deployments. The zero-tolerance bar keeps CI stable and new
contributors honest.

### III. Always-Source Configuration

User configuration files MUST source system defaults from
`/usr/share/tarion/defaults/`. System defaults are authoritative. User
overrides MUST be placed *outside* the sourced block so updates never erase
customizations. The `tarion-sync` utility MUST be run at login to ensure
symlinks are correct after image updates.

**Rationale**: Immutable desktops fail users when updates silently overwrite
their tweaks. The Always-Source model lets Tarion ship improvements without
breaking user environments.

### IV. Simplicity & YAGNI

Every new component MUST serve a current, demonstrated need. Abstractions,
helpers, and frameworks MUST NOT be introduced for hypothetical future
requirements. Three similar lines of code are preferable to a premature
abstraction. Feature flags, backwards-compatibility shims, and dead code MUST
be removed rather than retained.

**Rationale**: Tarion is a one-person-maintained distribution. Complexity
accumulates; YAGNI keeps it navigable and auditable.

### V. Validation-First Development

No change MUST be committed without passing all applicable validators:
`just validate-config` (Hyprland), `./scripts/lint-shell.sh` (ShellCheck),
and YAML syntax checks. CI gates in GitHub Actions MUST enforce these checks
on every push and pull request. A failing gate MUST block the merge.

**Rationale**: Validation is cheap; broken images are expensive. Catching
errors pre-commit is an order of magnitude faster than diagnosing a failed
container build.

## Technology Stack & Constraints

- **Base**: Universal Blue / Fedora Atomic 43 — rpm-ostree, immutable.
- **Window Manager**: Hyprland (COPR build, `--verify-config` required).
- **Desktop Shell**: DankMaterialShell (DMS) — theming via DMS native registry
  and matugen pipeline; no custom theme files in this repo.
- **Build System**: Blue Build v1 YAML recipes, multi-stage (cargo-builder →
  main). Module order is significant and MUST be respected.
- **Package Management**: DNF (system), Flatpak (desktop apps), Homebrew (CLI).
  The `tarion-pkg` wrapper is the canonical install interface for users.
- **Languages in use**: Bash/shell (scripts), YAML (recipes), Python (build
  tooling), Lua (Neovim). New languages MUST be justified; default to Bash for
  system scripts.
- **Secrets & credentials**: MUST NOT appear in any committed file. Use
  environment variables or secrets managers.

## Development Workflow & Quality Gates

1. **Make changes** — configs, scripts, or recipes.
2. **Validate locally** — run ShellCheck, Hyprland verify, and YAML lint.
3. **Commit** — use Conventional Commits (`feat:`, `fix:`, `docs:`, `refactor:`
   etc.). Pre-commit hooks MUST pass.
4. **Push** — GitHub Actions runs ShellCheck, config validation, YAML checks,
   and builds the container image. A broken build MUST be fixed before merging
   to `main`.
5. **Test** (optional but recommended for large changes) — `just iso` + `just
   test-iso` in QEMU.

**Review checklist** (apply to every PR):
- [ ] All shell scripts pass ShellCheck (zero warnings).
- [ ] All Hyprland configs pass `--verify-config`.
- [ ] All YAML recipes parse cleanly.
- [ ] No new complexity without justification (Principle IV).
- [ ] User-space configs source system defaults (Principle III).
- [ ] No base-image mutation attempted (Principle I).

## Governance

This constitution supersedes all other informal practices. Amendments MUST
follow semantic versioning:

- **MAJOR**: Removal or redefinition of a Core Principle.
- **MINOR**: Addition of a new principle or materially expanded guidance.
- **PATCH**: Clarifications, wording fixes, non-semantic refinements.

All pull requests and code reviews MUST verify compliance with the five Core
Principles above. Complexity violations MUST be documented in the plan's
Complexity Tracking table with explicit justification. Use `CLAUDE.md` for
runtime development context and `.specify/memory/constitution.md` (this file)
for governance decisions.

**Version**: 1.0.0 | **Ratified**: 2026-03-22 | **Last Amended**: 2026-03-22
