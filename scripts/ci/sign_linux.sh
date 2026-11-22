#!/usr/bin/env bash
# Creates a detached GPG signature for the Linux release archive and verifies it.
# Requires GPG_PRIVATE_KEY_BASE64, GPG_PASSPHRASE, RUNNER_TEMP, and LINUX_ARTIFACT_VERSION.
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

require_env GPG_PRIVATE_KEY_BASE64 GPG_PASSPHRASE

printf '%s' "$GPG_PRIVATE_KEY_BASE64" | base64 --decode | gpg --batch --import
artifact_version="${LINUX_ARTIFACT_VERSION:?LINUX_ARTIFACT_VERSION is required}"
archive="${RUNNER_TEMP}/free_rfr-linux-${artifact_version}.tar.gz"
signature="${archive}.asc"
tar -czf "$archive" -C build/linux/x64/release bundle
printf '%s' "$GPG_PASSPHRASE" | gpg --batch --yes --pinentry-mode loopback --passphrase-fd 0 --armor --detach-sign --output "$signature" "$archive"
gpg --verify "$signature" "$archive"
mv "$archive" "$signature" build/linux/x64/release/
