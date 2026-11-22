#!/usr/bin/env bash
# Verifies the AAB and APK were signed by the configured Android upload key.
# Requires ANDROID_KEYSTORE_PASSWORD, ANDROID_KEY_ALIAS, RUNNER_TEMP, and the Android SDK path.
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

require_env ANDROID_KEYSTORE_PASSWORD ANDROID_KEY_ALIAS

keystore="${RUNNER_TEMP}/free_rfr-upload.jks"
aab=$(find build/app/outputs/bundle/release -maxdepth 1 -name '*.aab' -print -quit)
apk=$(find build/app/outputs/flutter-apk -maxdepth 1 -name '*.apk' -print -quit)
if [ -z "$aab" ] || [ -z "$apk" ]; then
  echo "::error::Signed Android artifacts were not found"
  exit 1
fi

normalize() {
  tr -d ':' | tr '[:lower:]' '[:upper:]'
}

expected=$(keytool -list -v -keystore "$keystore" -storepass "$ANDROID_KEYSTORE_PASSWORD" -alias "$ANDROID_KEY_ALIAS" | awk -F': ' '/SHA256:/ {print $2; exit}' | normalize)
aab_cert=$(keytool -printcert -jarfile "$aab" | awk -F': ' '/SHA256:/ {print $2; exit}' | normalize)

sdk_root="${ANDROID_HOME:-${ANDROID_SDK_ROOT:-}}"
if [ -z "$sdk_root" ]; then
  echo "::error::Android SDK path is not available"
  exit 1
fi
apksigner=$(find "$sdk_root/build-tools" -type f -name apksigner -print -quit)
if [ -z "$apksigner" ]; then
  echo "::error::apksigner was not found in the Android SDK"
  exit 1
fi

jarsigner -verify "$aab"
"$apksigner" verify --print-certs "$apk"
apk_cert=$("$apksigner" verify --print-certs "$apk" | awk '/SHA-256 digest/ {print $NF; exit}' | normalize)

if [ -z "$expected" ] || [ "$expected" != "$aab_cert" ] || [ "$expected" != "$apk_cert" ]; then
  echo "::error::Android artifacts were not signed with the expected certificate"
  exit 1
fi
