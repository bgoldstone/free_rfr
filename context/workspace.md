# Workspace hygiene

- Machine-specific signing paths, identities, and local key locations belong in `AGENTS.local.md` (gitignored); do not commit them.
- Leave `.vscode/`, `.sonarlint/`, and `analysis_options.yaml` local; do not stage them without an explicit request.
- In this workspace, push workflow changes over SSH; HTTPS OAuth lacks workflow scope for `.github/workflows/flutter_build.yml`.
