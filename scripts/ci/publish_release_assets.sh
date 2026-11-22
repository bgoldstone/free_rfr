#!/usr/bin/env bash
# Packages downloaded CI artifacts and attaches them to the GitHub release for the current tag.
# Requires GH_TOKEN, GITHUB_REF_NAME, and the release-assets directory populated by actions/download-artifact.
set -euo pipefail

tag="${GITHUB_REF_NAME:?GITHUB_REF_NAME is required}"
: "${GH_TOKEN:?GH_TOKEN is required}"

root="release-assets"
if [ ! -d "$root" ]; then
  echo "::error::Release assets directory was not found"
  exit 1
fi

archives=()
for directory in "$root"/*; do
  [ -d "$directory" ] || continue
  name=$(basename "$directory")
  archive="$PWD/$root/$name.zip"
  (cd "$directory" && zip -qr "$archive" .)
  archives+=("$archive")
done

if [ ${#archives[@]} -eq 0 ]; then
  echo "::error::No release artifacts were found"
  exit 1
fi

if gh release view "$tag" >/dev/null 2>&1; then
  gh release upload "$tag" "${archives[@]}" --clobber
else
  gh release create "$tag" "${archives[@]}" --verify-tag --generate-notes --title "$tag"
fi
