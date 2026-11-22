#!/usr/bin/env bash
# Imports iOS signing material, exports a signed IPA from the Flutter archive, and verifies the embedded app.
# Requires the IOS_* secrets and RUNNER_TEMP; ALLOW_SELF_SIGNED_SIGNATURES defaults to true.
set -euo pipefail

require_env() {
  local name
  for name in "$@"; do
    if [ -z "$(printenv "$name")" ]; then
      echo "::error::Missing required secret: $name"
      exit 1
    fi
  done
}

decode_base64() {
  if printf '' | base64 --decode >/dev/null 2>&1; then
    base64 --decode
  else
    base64 -D
  fi
}

require_env IOS_CERTIFICATE_BASE64 IOS_CERTIFICATE_PASSWORD IOS_PROVISIONING_PROFILE_BASE64 IOS_PROVISIONING_PROFILE_NAME IOS_TEAM_ID

allow_self_signed="${ALLOW_SELF_SIGNED_SIGNATURES:-true}"
export_method="${IOS_EXPORT_METHOD:-app-store}"
keychain="${RUNNER_TEMP}/free-rfr-ios.keychain-db"
certificate="${RUNNER_TEMP}/ios-signing.p12"
profile="${RUNNER_TEMP}/free_rfr.mobileprovision"
options="${RUNNER_TEMP}/ExportOptions.plist"
extract_dir="${RUNNER_TEMP}/ios-ipa"
keychain_password=$(openssl rand -hex 24)

cleanup() {
  if [ -n "${keychain:-}" ]; then
    security delete-keychain "$keychain" >/dev/null 2>&1 || true
  fi
  rm -f "${certificate:-}" "${profile:-}" "${options:-}"
  if [ -n "${extract_dir:-}" ]; then
    rm -rf "$extract_dir"
  fi
}
trap cleanup EXIT

printf '%s' "$IOS_CERTIFICATE_BASE64" | decode_base64 > "$certificate"
printf '%s' "$IOS_PROVISIONING_PROFILE_BASE64" | decode_base64 > "$profile"
security create-keychain -p "$keychain_password" "$keychain"
security unlock-keychain -p "$keychain_password" "$keychain"
security import "$certificate" -k "$keychain" -P "$IOS_CERTIFICATE_PASSWORD" -T /usr/bin/codesign
security set-key-partition-list -S apple-tool:,apple:,codesign: -s -k "$keychain_password" "$keychain" > /dev/null
existing=$(security list-keychains -d user | tr -d '"')
read -r -a keychains <<< "$existing"
security list-keychains -d user -s "$keychain" "${keychains[@]}"
mkdir -p "$HOME/Library/MobileDevice/Provisioning Profiles"
cp "$profile" "$HOME/Library/MobileDevice/Provisioning Profiles/free_rfr.mobileprovision"

IOS_EXPORT_METHOD="$export_method" IOS_EXPORT_OPTIONS_PATH="$options" IOS_TEAM_ID="$IOS_TEAM_ID" IOS_PROVISIONING_PROFILE_NAME="$IOS_PROVISIONING_PROFILE_NAME" python3 - <<'PY'
import os
import plistlib

options = {
    "method": os.environ["IOS_EXPORT_METHOD"],
    "teamID": os.environ["IOS_TEAM_ID"],
    "signingStyle": "manual",
    "provisioningProfiles": {
        "com.github.bgoldstone.free_rfr": os.environ["IOS_PROVISIONING_PROFILE_NAME"]
    },
}
with open(os.environ["IOS_EXPORT_OPTIONS_PATH"], "wb") as file:
    plistlib.dump(options, file)
PY

flutter build ipa --release --no-codesign
xcodebuild -exportArchive \
  -archivePath build/ios/archive/Runner.xcarchive \
  -exportOptionsPlist "$options" \
  -exportPath build/ios/ipa

ipa=$(find build/ios/ipa -maxdepth 2 -name '*.ipa' -print -quit)
if [ -z "$ipa" ]; then
  echo "::error::Signed IPA was not found"
  exit 1
fi
mkdir -p "$extract_dir"
unzip -q "$ipa" -d "$extract_dir"
app=$(find "$extract_dir/Payload" -maxdepth 1 -name '*.app' -print -quit)
if [ -z "$app" ]; then
  echo "::error::Signed app was not found in IPA"
  exit 1
fi
if [ "$allow_self_signed" = "true" ]; then
  codesign --display --verbose=2 "$app" > /dev/null
else
  codesign --verify --deep --strict --verbose=2 "$app"
fi
