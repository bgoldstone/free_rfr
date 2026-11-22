#!/usr/bin/env bash
# Materializes the Android upload keystore and writes android/key.properties for Gradle.
# Requires the ANDROID_* secrets and RUNNER_TEMP.
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

require_env ANDROID_KEYSTORE_BASE64 ANDROID_KEYSTORE_PASSWORD ANDROID_KEY_PASSWORD ANDROID_KEY_ALIAS

keystore="${RUNNER_TEMP}/free_rfr-upload.jks"
printf '%s' "$ANDROID_KEYSTORE_BASE64" | base64 --decode > "$keystore"
chmod 600 "$keystore"

ANDROID_KEYSTORE_PATH="$keystore" python3 - <<'PY'
import os
from pathlib import Path

def escape(value: str) -> str:
    return value.replace("\\", "\\\\").replace(":", "\\:")

lines = [
    f"storePassword={escape(os.environ['ANDROID_KEYSTORE_PASSWORD'])}",
    f"keyPassword={escape(os.environ['ANDROID_KEY_PASSWORD'])}",
    f"keyAlias={escape(os.environ['ANDROID_KEY_ALIAS'])}",
    f"storeFile={escape(os.environ['ANDROID_KEYSTORE_PATH'])}",
]
Path("android/key.properties").write_text("\n".join(lines) + "\n", encoding="utf-8")
PY
chmod 600 android/key.properties
