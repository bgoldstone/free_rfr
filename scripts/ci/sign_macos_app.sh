#!/usr/bin/env bash
# Signs the built macOS app with the supplied Developer ID identity and verifies the signature.
# Requires the MACOS_* secrets, RUNNER_TEMP, and ALLOW_SELF_SIGNED_SIGNATURES.
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

require_env MACOS_CERTIFICATE_BASE64 MACOS_CERTIFICATE_PASSWORD MACOS_SIGNING_IDENTITY

allow_self_signed="${ALLOW_SELF_SIGNED_SIGNATURES:-true}"
keychain="${RUNNER_TEMP}/free-rfr-macos.keychain-db"
certificate="${RUNNER_TEMP}/macos-signing.p12"
keychain_password=$(openssl rand -hex 24)

cleanup() {
  if [ -n "${keychain:-}" ]; then
    security delete-keychain "$keychain" >/dev/null 2>&1 || true
  fi
  rm -f "${certificate:-}"
}
trap cleanup EXIT

printf '%s' "$MACOS_CERTIFICATE_BASE64" | decode_base64 > "$certificate"
security create-keychain -p "$keychain_password" "$keychain"
security set-keychain-settings -lut 21600 "$keychain"
security unlock-keychain -p "$keychain_password" "$keychain"
security import "$certificate" -k "$keychain" -P "$MACOS_CERTIFICATE_PASSWORD" -T /usr/bin/codesign
security set-key-partition-list -S apple-tool:,apple:,codesign: -s -k "$keychain_password" "$keychain" > /dev/null
existing=$(security list-keychains -d user | tr -d '"')
read -r -a keychains <<< "$existing"
security list-keychains -d user -s "$keychain" "${keychains[@]}"

app=$(find build/macos/Build/Products/Release -maxdepth 1 -name '*.app' -print -quit)
if [ -z "$app" ]; then
  echo "::error::macOS app was not found"
  exit 1
fi
codesign --force --deep --options runtime --sign "$MACOS_SIGNING_IDENTITY" "$app"
if [ "$allow_self_signed" = "true" ]; then
  signer=$(codesign --display --verbose=4 "$app" 2>&1 | awk -F'= ' '/^Authority=/ {print $2; exit}')
  if [ "$signer" != "$MACOS_SIGNING_IDENTITY" ]; then
    echo "::error::macOS app was signed with an unexpected identity"
    exit 1
  fi
else
  codesign --verify --deep --strict --verbose=2 "$app"
fi
