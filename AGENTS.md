# AGENTS

Read only the relevant `context/*.md` file(s) before changing code, workflows, or docs; do not load the full context set unless the task spans multiple areas:

- `context/commands.md` — formatting, validation, coverage, pinned toolchain.
- `context/architecture.md` — app entrypoint, state ownership, OSC transport, fader/color-picker behavior.
- `context/testing.md` — widget-test setup, mocks, platform overrides, config-file tests.
- `context/dependencies.md` — pubspec/native-build traps, Gradle language, lockfile expectations.
- `context/ci-cd.md` — workflow shape, verify gate, build modes, caches, artifacts, signing, release publishing.
- `context/workspace.md` — local-only files, local signing context, SSH push requirement.

## Global rules

- Make atomic commits: one logical change per commit, including related tests and changelog entries.
- Commit or push only when explicitly requested.
- Keep `CHANGELOG.md` updated in the same commit as user-visible changes; use the version heading from `pubspec.yaml` and do not create placeholder sections.
- Do not read `CHANGELOG.md` unless explicitly asked; update it from the current task context without opening it.
- Never mix local-only workspace files into commits.
