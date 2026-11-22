#!/usr/bin/env bash
# Reports whether all platform signing keys are configured for a tagged release.
# Requires GITHUB_OUTPUT and the *_SIGNING_READY environment flags; writes publish=true|false.
set -euo pipefail

publish=true
for platform in ANDROID LINUX WINDOWS IOS MACOS; do
  ready_var="${platform}_SIGNING_READY"
  if [ "${!ready_var:-false}" != "true" ]; then
    publish=false
  fi
done

echo "publish=$publish" >> "${GITHUB_OUTPUT:?GITHUB_OUTPUT is required}"
