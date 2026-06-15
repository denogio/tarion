# Feature Specification: Install Valent for DMS Phone Connect

**Feature Branch**: `001-valent-phone-connect`
**Created**: 2026-03-23
**Status**: Draft
**Input**: User description: "install valent to be able to enable DMS phone connect"

## Clarifications

### Session 2026-03-23

- Q: How should Valent be installed — DNF/COPR (baked into system image) or Flatpak (user space)? → A: Flatpak from Flathub
- Q: Does DMS Phone Connect auto-detect Valent when running, or does explicit configuration need to be added? → A: DMS auto-detects Valent — no explicit config needed beyond installation
- Q: Should firewall ports be configured in the image? → A: No — Tarion does not ship firewalld config; out of scope

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Phone Pairing Out of the Box (Priority: P1)

A Tarion user wants to connect their smartphone to their desktop so they can use DMS Phone Connect. After a fresh Tarion install, Valent is already present on the system — the user opens DMS Phone Connect, pairs their phone, and the connection works without any manual package installation.

**Why this priority**: Phone connectivity is a core DMS feature. Users expect it to work on a fresh install without manual intervention. This is the minimum viable outcome of this feature.

**Independent Test**: Can be fully tested by booting a fresh Tarion image, opening DMS Phone Connect, and verifying that Valent is available and the pairing flow is accessible — delivering a working phone connection without any additional setup.

**Acceptance Scenarios**:

1. **Given** a fresh Tarion installation, **When** the user opens DMS Phone Connect, **Then** the feature is available and Valent is running as the backend without requiring any manual package installation.
2. **Given** Valent is installed and the user has a smartphone with KDE Connect or a compatible app, **When** the user initiates pairing from DMS Phone Connect, **Then** the device is discovered and can be paired successfully.
3. **Given** a paired phone, **When** the user opens DMS Phone Connect, **Then** the paired device is shown as connected and available.

---

### User Story 2 - Persistent Connection Across Sessions (Priority: P2)

A Tarion user expects their paired phone to reconnect automatically when they log back into their desktop session, without having to re-pair each time.

**Why this priority**: Auto-reconnect is essential usability. Without it, phone pairing is a constant manual chore and the feature loses practical value.

**Independent Test**: Can be tested by pairing a phone, logging out and back in, and verifying that the phone reconnects automatically via DMS Phone Connect.

**Acceptance Scenarios**:

1. **Given** a phone was previously paired, **When** the user logs into a new desktop session, **Then** Valent starts automatically and the phone reconnects without user interaction.
2. **Given** Valent is running and a paired phone comes back into range, **When** the phone reconnects, **Then** DMS Phone Connect reflects the connected state.

---

### Edge Cases

- What happens when Valent is installed but the required network ports are not open — does pairing fail gracefully with a clear indication?
- How does the system behave if the user's phone does not have KDE Connect or a compatible app installed?
- What happens if Valent fails to start at login — does DMS Phone Connect indicate that connectivity is unavailable?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Valent MUST be installed as a Flatpak (from Flathub) as part of the Tarion image build so it is available on every fresh installation without manual user action.
- **FR-002**: Valent MUST be configured to launch automatically at user login via an XDG autostart entry so phone pairing is available without manual start.
- **FR-004**: DMS Phone Connect MUST automatically detect and use Valent when it is installed and running — no explicit backend configuration is required beyond Valent's presence.
- **FR-005**: The Valent Flatpak MUST start automatically as part of the user session via XDG autostart, without requiring root access or manual intervention.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A fresh Tarion installation provides a working DMS Phone Connect experience with zero manual steps required from the user.
- **SC-002**: Phone pairing can be completed in under 2 minutes from opening DMS Phone Connect for the first time.
- **SC-003**: A previously paired phone reconnects automatically within 30 seconds of the user logging into a new session.
- **SC-004**: 100% of fresh Tarion installations include Valent with all required services and ports configured correctly.

## Assumptions

- Valent is available on Flathub and will be installed as a Flatpak during the Tarion image build using the existing Flatpak module in the recipe.
- DMS Phone Connect auto-detects Valent when it is installed and running — no explicit configuration of the DMS backend is required.
- The user's phone must have KDE Connect or a compatible application installed separately — this is outside the scope of this feature.
- Firewall port configuration is out of scope — Tarion does not ship a firewalld configuration. Users needing port access configure firewalld manually.
- User session autostart for Valent uses XDG autostart conventions, consistent with other Flatpak desktop applications in Tarion.
