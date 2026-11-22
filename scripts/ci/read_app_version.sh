#!/usr/bin/env bash
# Reads the app version from pubspec.yaml and exports APP_VERSION and per-platform artifact tags.
# Requires GITHUB_ENV; uses SIGN_RELEASE and *_SIGNING_READY to decide snapshot suffixes.
set -euo pipefail

version=$(awk '/^version:/ { sub(/^version:[[:space:]]*/, ""); print; exit }' pubspec.yaml | tr -d '"' | tr -d "'" | tr -d '[:space:]')
if [ -z "$version" ]; then
  echo "::error::Version was not found in pubspec.yaml"
  exit 1
fi
if [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+(\+[0-9]+)?$ ]]; then
  echo "::error::Invalid version in pubspec.yaml: $version"
  exit 1
fi

github_env="${GITHUB_ENV:?GITHUB_ENV is required}"
release="${SIGN_RELEASE:-false}"
{
  echo "APP_VERSION=$version"
  for platform in ANDROID LINUX WINDOWS IOS MACOS; do
    ready_var="${platform}_SIGNING_READY"
    artifact_version="$version"
    if [[ "$release" != "true" || "${!ready_var:-false}" != "true" ]]; then
      artifact_version="${version}-snapshot"
    fi
    echo "${platform}_ARTIFACT_VERSION=$artifact_version"
  done
} >> "$github_env"
