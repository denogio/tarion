---
description: "Task list for Install Valent for DMS Phone Connect"
---

# Tasks: Install Valent for DMS Phone Connect

**Input**: Design documents from `/specs/001-valent-phone-connect/`
**Prerequisites**: plan.md ✅, spec.md ✅, research.md ✅, quickstart.md ✅

**Tests**: Not requested — this is a recipe/config-only change with manual ISO verification.

**Organization**: Tasks grouped by user story. Both user stories (US1: pairing out of the box, US2: persistent reconnect) are delivered by the same two implementation changes, so they share Phase 2.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (no interdependency)
- **[Story]**: User story this task belongs to

## Path Conventions

This is a distribution configuration feature. All changes are in the repository root:
- `recipes/stages/` — Blue Build YAML recipe stages
- `files/system/etc/` — Static files copied into the image at `/etc/`

---

## Phase 1: Setup

**Purpose**: Confirm working environment before making changes.

- [ ] T001 Confirm feature branch `001-valent-phone-connect` is checked out and repo is clean

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: The two recipe/config changes that deliver both user stories. No user story work can be independently validated until both are done.

**⚠️ CRITICAL**: Both T002 and T003 must be complete before either user story can be tested.

- [ ] T002 [P] Add GNOME Nightly remote and `ca.andyholmes.Valent` to system-scope Flatpak install list in `recipes/stages/03-apps.yml`
- [ ] T003 [P] Create XDG autostart entry at `files/system/etc/xdg/autostart/ca.andyholmes.Valent.desktop` that runs `flatpak run ca.andyholmes.Valent` silently at login

**Checkpoint**: Both files changed — feature is structurally complete. Proceed to validation.

---

## Phase 3: User Story 1 — Phone Pairing Out of the Box (Priority: P1) 🎯 MVP

**Goal**: Fresh Tarion install has Valent available and DMS Phone Connect can pair a phone without any manual steps.

**Independent Test**: Boot a fresh Tarion image → open DMS Phone Connect → verify Valent is running as the backend and a phone (with KDE Connect installed) can be paired. See `quickstart.md` for full test steps.

### Implementation for User Story 1

- [ ] T004 [US1] Validate YAML syntax of `recipes/stages/03-apps.yml` after T002 (`python3 -c "import yaml; yaml.safe_load(open('recipes/stages/03-apps.yml'))"`)
- [ ] T005 [US1] Verify `files/system/etc/xdg/autostart/ca.andyholmes.Valent.desktop` is valid XDG Desktop Entry format (required keys: `Type`, `Name`, `Exec`)

**Checkpoint**: User Story 1 is deliverable — Valent installs on boot and autostarts, enabling DMS Phone Connect pairing.

---

## Phase 4: User Story 2 — Persistent Connection Across Sessions (Priority: P2)

**Goal**: Previously paired phone reconnects automatically on next login without re-pairing.

**Independent Test**: Pair a phone in a VM → log out → log back in → verify Valent has restarted automatically and the phone reconnects.

**Note**: US2 is fully satisfied by T003 (the autostart entry). No additional implementation tasks are needed beyond what Phase 2 delivered.

### Implementation for User Story 2

- [ ] T006 [US2] Confirm `NoDisplay=true` is set in `files/system/etc/xdg/autostart/ca.andyholmes.Valent.desktop` so the autostart entry is silent (no app window opens at login)

**Checkpoint**: User Stories 1 AND 2 are both satisfied. Valent starts silently each session and maintains paired connections.

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Validation gate before commit, ensuring no regressions.

- [ ] T007 [P] Run `./scripts/lint-shell.sh` to confirm no ShellCheck regressions (no new shell scripts added, but run to satisfy Principle V)
- [ ] T008 [P] Run `just validate-config` to confirm Hyprland configs unaffected
- [ ] T009 [P] Validate main recipe YAML (`python3 -c "import yaml; yaml.safe_load(open('recipes/recipe.yml'))"`)
- [ ] T010 Run `/validate` (Tarion validation pipeline) to confirm all checks pass before committing
- [ ] T011 Commit changes with `/commit` using conventional commit: `feat: install Valent Flatpak and XDG autostart for DMS Phone Connect`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — start immediately
- **Foundational (Phase 2)**: Depends on Phase 1 — T002 and T003 can run in parallel with each other
- **User Story Phases (3–4)**: Both depend on Phase 2 completion; US1 and US2 validation can run in parallel
- **Polish (Phase 5)**: Depends on all story phases complete; T007/T008/T009 can run in parallel

### User Story Dependencies

- **US1 (P1)**: Satisfied by T002 + T003; T004 + T005 are validation only
- **US2 (P2)**: Satisfied by T003; T006 is a detail check within that same file

### Parallel Opportunities

- T002 and T003 are independent files — can be done simultaneously
- T004, T005, T007, T008, T009 are all read-only validations — can all run in parallel

---

## Parallel Example: Phase 2

```bash
# Both changes are in different files — implement simultaneously:
Task T002: "Add Valent to recipes/stages/03-apps.yml"
Task T003: "Create files/system/etc/xdg/autostart/ca.andyholmes.Valent.desktop"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (T001)
2. Complete Phase 2: T002 + T003 in parallel
3. Complete Phase 3: T004 + T005 validation
4. **STOP and VALIDATE**: Boot image in QEMU, confirm DMS Phone Connect works
5. If validated, proceed to Polish

### Incremental Delivery

1. T001 → T002 + T003 → T004 + T005 → MVP (US1 done) ✓
2. T006 → US2 verified (no code change needed) ✓
3. T007 + T008 + T009 + T010 → T011 → Done

---

## Notes

- [P] tasks operate on different files — safe to parallelize
- No shell scripts are added by this feature; ShellCheck is a regression guard only
- The `files` module in `05-config.yml` already copies `system/etc` → `/etc`, so the autostart file requires no recipe changes beyond creating the file
- Manual ISO test (`just iso` + `just test-iso`) is the definitive acceptance gate
- Valent is nightly-only (not on Flathub stable) — see `research.md` for the GNOME Nightly remote URL and repo file
