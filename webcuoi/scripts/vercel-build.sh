#!/usr/bin/env bash
set -euo pipefail

export PATH="${PWD}/.flutter-sdk/bin:${PATH}"

BUILD_ARGS=(build web --release --no-pub)
if [[ -n "${API_BASE_URL:-}" ]]; then
  BUILD_ARGS+=("--dart-define=API_BASE_URL=${API_BASE_URL}")
fi

flutter "${BUILD_ARGS[@]}"

if [[ ! -f "build/web/index.html" ]]; then
  echo "Flutter Web output is missing: build/web/index.html" >&2
  exit 1
fi
