# CI and release

## Workflow shape

- `.github/workflows/flutter_build.yml` triggers on `push` to `main`, `v*` tags, PRs to `main`, and manual dispatch. Pushes to `dev` do not trigger CI.
- A `verify` job runs first on Ubuntu and gates all build jobs with `needs: verify`; it runs `flutter pub get --enforce-lockfile`, format check, `flutter analyze`, and `flutter test`.
- Build jobs then run in parallel: `build-android`, `build-linux`, `build-windows`, `build-ios`, `build-macos`.
- PR builds use debug mode for Android, Linux, and Windows; iOS and macOS jobs are skipped on PRs.
- `main` pushes, `v*` tags, and manual dispatch use release mode for every platform.
- Top-level concurrency cancels superseded PR runs; `main`, tag, and manual runs are not cancelled.
- Flutter SDK and pub caches are enabled through `subosito/flutter-action`; Android uses `actions/setup-java` Gradle caching; Linux caches ccache for CMake builds; iOS/macOS cache `~/Library/Caches/CocoaPods` and Xcode `DerivedData`.
- Flutter SDK version comes from `.fvmrc` so Windows jobs avoid `yq` installation.

## Release artifacts

- `release-assets` runs only for `v*` tags and depends on `verify` plus every build job.
- Do not replace the `release-assets` tag check with `env.IS_RELEASE`: job-level `if` cannot reliably use top-level `env`, and `IS_RELEASE` is true on manual dispatch where `github.ref_name` is a branch, not a tag.
- `scripts/ci/publish_release_assets.sh` uses `GITHUB_REF_NAME` as the release tag and requires `GH_TOKEN`.
- Tag builds upload all packaged `free_rfr-*` artifacts to the GitHub release, even if some platforms are unsigned; missing signing secrets skip only that platform's signing step and do not change artifact tags.
- `GITHUB_TOKEN` is automatic; do not create it as a repository secret. The `release-assets` job requests `contents: write` so it can create or update the tag release.

## Signing

- Sign activates only for `v*` tags and manual dispatch; PR and `main` builds remain unsigned.
- `IS_RELEASE` (formerly `SIGN_RELEASE`) is computed from `v*` tags or manual dispatch. `scripts/ci/read_app_version.sh` reads it from the environment and appends `-snapshot` only for non-release builds.
- `ALLOW_SELF_SIGNED_SIGNATURES` defaults to `true` for self-signed development certificates; set it to `false` to require trusted OS chains.
- Signing logic lives in `scripts/ci`; keep workflow steps thin and pass secrets through environment variables.
- Android creates `android/key.properties` from `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_PASSWORD`, and `ANDROID_KEY_ALIAS`.
- Windows signs `.exe`/`.dll` files from `WINDOWS_PFX_BASE64` and `WINDOWS_PFX_PASSWORD`.
- macOS signs the `.app` from `MACOS_CERTIFICATE_BASE64`, `MACOS_CERTIFICATE_PASSWORD`, and `MACOS_SIGNING_IDENTITY`.
- iOS exports a signed IPA from `IOS_CERTIFICATE_BASE64`, `IOS_CERTIFICATE_PASSWORD`, `IOS_PROVISIONING_PROFILE_BASE64`, `IOS_PROVISIONING_PROFILE_NAME`, `IOS_TEAM_ID`, and optional `IOS_EXPORT_METHOD`.
- Linux creates a detached GPG signature from `GPG_PRIVATE_KEY_BASE64` and `GPG_PASSPHRASE`.
- Temporary macOS/iOS keychain passwords are generated inside CI; do not add them as secrets.
- Signing secret setup commands and all `scripts/ci` helpers are documented in `docs/release-signing.md`.
