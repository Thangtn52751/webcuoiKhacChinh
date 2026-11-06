#!/usr/bin/env bash
set -euo pipefail

export PATH="${PWD}/.flutter-sdk/bin:${PATH}"

# Use the deployed backend unless this Vercel project overrides API_BASE_URL.
BUILD_ARGS=(
  build web --release --no-pub
  "--dart-define=API_BASE_URL=${API_BASE_URL:-https://webcuoi-khac-chinh.vercel.app/api}"
)

flutter "${BUILD_ARGS[@]}"

if [[ ! -f "build/web/index.html" ]]; then
  echo "Flutter Web output is missing: build/web/index.html" >&2
  exit 1
fi
