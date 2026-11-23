# Release signing setup

Release signing runs only for `v*` tags and manual `workflow_dispatch` runs. Pull requests and `main` builds stay unsigned.

The workflow delegates work to these scripts in `scripts/ci`:

| Script | Purpose | Inputs / outputs |
| --- | --- | --- |
| `read_app_version.sh` | Reads the pubspec version and artifact tags | Reads `pubspec.yaml` and `IS_RELEASE`; writes `APP_VERSION` and `*_ARTIFACT_VERSION` to `GITHUB_ENV` |
| `prepare_android_signing.sh` | Creates the Android keystore and `android/key.properties` | Reads `ANDROID_*` secrets and `RUNNER_TEMP` |
| `verify_android_artifacts.sh` | Verifies the AAB and APK certificate fingerprints | Reads `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `RUNNER_TEMP`, and Android SDK paths |
| `sign_linux.sh` | Creates and verifies the Linux GPG archive signature | Reads `GPG_PRIVATE_KEY_BASE64`, `GPG_PASSPHRASE`, `RUNNER_TEMP`, and `LINUX_ARTIFACT_VERSION` |
| `sign_windows.ps1` | Signs and verifies Windows PE files | Reads `WINDOWS_PFX_BASE64`, `WINDOWS_PFX_PASSWORD`, `RUNNER_TEMP`, and `ALLOW_SELF_SIGNED_SIGNATURES` |
| `export_ios_ipa.sh` | Exports and verifies a signed IPA | Reads `IOS_*` secrets, `RUNNER_TEMP`, and `ALLOW_SELF_SIGNED_SIGNATURES` |
| `sign_macos_app.sh` | Signs and verifies the macOS app | Reads `MACOS_*` secrets, `RUNNER_TEMP`, and `ALLOW_SELF_SIGNED_SIGNATURES` |
| `publish_release_assets.sh` | Packages and uploads released artifacts | Reads `GH_TOKEN`, `GITHUB_REF_NAME`, and `release-assets/` |

## Artifact naming

`scripts/ci/read_app_version.sh` reads the version from `pubspec.yaml` and sets `APP_VERSION` plus per-platform artifact tags. Release builds use the version alone, for example `free_rfr-windows-1.0.3+0`, even when a platform's signing secrets are missing. Non-release builds append `-snapshot`, for example `free_rfr-windows-1.0.3+0-snapshot`. The Linux GPG archive and signature use the Linux tag.

Tag builds upload the packaged build artifacts to the GitHub release for that tag. Missing secrets skip that platform's signing step but do not change the artifact tag.

## Required GitHub repository secrets

| Secret | Format |
| --- | --- |
| `ANDROID_KEYSTORE_BASE64` | Base64 of the Android upload keystore file |
| `ANDROID_KEYSTORE_PASSWORD` | Android keystore password |
| `ANDROID_KEY_PASSWORD` | Android key password |
| `ANDROID_KEY_ALIAS` | Android key alias |
| `WINDOWS_PFX_BASE64` | Base64 of the Authenticode PFX file |
| `WINDOWS_PFX_PASSWORD` | PFX password |
| `MACOS_CERTIFICATE_BASE64` | Base64 of the macOS Developer ID P12 file |
| `MACOS_CERTIFICATE_PASSWORD` | macOS P12 password |
| `MACOS_SIGNING_IDENTITY` | Exact signing identity, for example `Developer ID Application: Name (TEAMID)` |
| `IOS_CERTIFICATE_BASE64` | Base64 of the iOS distribution P12 file |
| `IOS_CERTIFICATE_PASSWORD` | iOS P12 password |
| `IOS_PROVISIONING_PROFILE_BASE64` | Base64 of the `.mobileprovision` file |
| `IOS_PROVISIONING_PROFILE_NAME` | Provisioning profile name, not its filename |
| `IOS_TEAM_ID` | Apple Developer team ID |
| `GPG_PRIVATE_KEY_BASE64` | Base64 of the exported GPG private key used for Linux artifacts |
| `GPG_PASSPHRASE` | GPG private key passphrase |

`IOS_EXPORT_METHOD` is optional and defaults to `app-store`. Valid examples are `app-store`, `ad-hoc`, `development`, and `enterprise`.

`GITHUB_TOKEN` is generated automatically for every workflow run; do not create it as a repository secret. The `release-assets` job requests `contents: write` so it can create or update the GitHub release for the tag.

## GitHub CLI setup commands

Run these from the repository root in PowerShell. Values are read from files or prompts and are not printed.

```powershell
gh auth login

function Set-RepoSecret {
  param([string]$Name)
  $value = Read-Host -MaskInput "Value for $Name"
  [System.Net.NetworkCredential]::new('', $value).Password | gh secret set $Name
}

function Set-RepoFileSecret {
  param([string]$Name, [string]$Path)
  [Convert]::ToBase64String([IO.File]::ReadAllBytes($Path)) | gh secret set $Name
}

Set-RepoFileSecret ANDROID_KEYSTORE_BASE64 .\path\to\upload.jks
Set-RepoSecret ANDROID_KEYSTORE_PASSWORD
Set-RepoSecret ANDROID_KEY_PASSWORD
Set-RepoSecret ANDROID_KEY_ALIAS

Set-RepoFileSecret WINDOWS_PFX_BASE64 .\path\to\code-signing.pfx
Set-RepoSecret WINDOWS_PFX_PASSWORD

Set-RepoFileSecret MACOS_CERTIFICATE_BASE64 .\path\to\developer-id.p12
Set-RepoSecret MACOS_CERTIFICATE_PASSWORD
Set-RepoSecret MACOS_SIGNING_IDENTITY

Set-RepoFileSecret IOS_CERTIFICATE_BASE64 .\path\to\ios-distribution.p12
Set-RepoSecret IOS_CERTIFICATE_PASSWORD
Set-RepoFileSecret IOS_PROVISIONING_PROFILE_BASE64 .\path\to\profile.mobileprovision
Set-RepoSecret IOS_PROVISIONING_PROFILE_NAME
Set-RepoSecret IOS_TEAM_ID

Set-RepoFileSecret GPG_PRIVATE_KEY_BASE64 .\path\to\private-key.gpg
Set-RepoSecret GPG_PASSPHRASE

gh secret set IOS_EXPORT_METHOD --body app-store
```

Verify the repository configuration with:

```powershell
gh secret list
gh variable list
```

## Repository variable

`ALLOW_SELF_SIGNED_SIGNATURES` defaults to `true`, which allows self-signed test certificates to pass CI while still checking that artifacts were signed by the supplied certificate and were not modified afterward.

For trusted public releases, require a valid OS trust chain:

```powershell
gh variable set ALLOW_SELF_SIGNED_SIGNATURES --body false
```

Self-signed certificates are not trusted by Windows SmartScreen, Gatekeeper, or iOS. iOS signed IPA export also requires an Apple-issued certificate, provisioning profile, and team ID.

## Workflow-managed variables

Do not create these as repository secrets or variables:

- Flutter `3.50.1` is pinned in `pubspec.yaml` and read by CI via `flutter-version-file`.
- `IS_RELEASE` is computed from the trigger.
- `RUNNER_TEMP`, `ANDROID_HOME`, and `ANDROID_SDK_ROOT` are supplied by GitHub runners.
- Temporary macOS/iOS keychain passwords are generated in the scripts.

## Running scripts locally

Scripts read values from the environment. For example:

```powershell
$env:WINDOWS_PFX_BASE64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes('.\path\to\code-signing.pfx'))
$env:WINDOWS_PFX_PASSWORD = Read-Host -MaskInput
$env:ALLOW_SELF_SIGNED_SIGNATURES = 'true'
.\scripts\ci\sign_windows.ps1
```

Use `bash scripts/ci/<script>.sh` for the shell scripts on Linux or macOS.
