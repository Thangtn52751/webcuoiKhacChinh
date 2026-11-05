#!/usr/bin/env bash
set -euo pipefail

FLUTTER_VERSION="3.47.0"
FLUTTER_DIR="${PWD}/.flutter-sdk"
FLUTTER_ARCHIVE="/tmp/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"

if [[ ! -x "${FLUTTER_DIR}/bin/flutter" ]]; then
  mkdir -p "${FLUTTER_DIR}"
  curl --fail --location --retry 3 --output "${FLUTTER_ARCHIVE}" "${FLUTTER_URL}"
  tar -xf "${FLUTTER_ARCHIVE}" --strip-components=1 -C "${FLUTTER_DIR}"
  rm -f "${FLUTTER_ARCHIVE}"
fi

export PATH="${FLUTTER_DIR}/bin:${PATH}"
flutter config --no-analytics
flutter precache --web
flutter pub get
