# Changelog

All notable changes to this project are documented here.

## [Unreleased]

### Added
- `CHANGELOG.md` and an `AGENTS.md` rule to update it with each commit.

## [1.0.2+3] - Unreleased

### Added
- Signed Android release workflow for tagged and manual builds.
- Expanded characterization and widget-test coverage across OSC, pages, controls, shortcuts, and context state.
- Contributor and toolchain notes in `AGENTS.md`.
- Generated coverage reports are ignored via `coverage/`.

### Changed
- Upgraded Flutter to `3.50.1` and the Kotlin Gradle plugin to `2.4.20`.
- Pinned `hotkey_manager` to `0.2.3` and declared `material_ui` as a direct dependency.
- Reformatted Dart sources with `dart format .`.

### Fixed
- Fixed color-picker widget tests under `material_ui` by disabling legacy labels.
- Downgraded `hotkey_manager_linux` uninitialized-variable warnings from errors in Linux builds.
- Connection tests now fake `PathProviderPlatform` with per-test temporary directories.

## [1.0.1+2] - 2025-01-18

### Added
- New features from `New Features (#7)`.
- Security policy, code of conduct, README updates, and CI workflow updates.

### Changed
- Patch release packaging and workflow cleanup.

## [1.0.1+1] - 2024-04-01

### Added
- Initial tagged release with the core remote-control UI, OSC/TCP support, faders, direct selects, cues, shortcuts, and multi-console connections.
