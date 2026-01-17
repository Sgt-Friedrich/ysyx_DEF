#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$ROOT_DIR/defense_package.zip"

if ! command -v zip >/dev/null 2>&1; then
  echo "zip not found. Install with: sudo apt-get install -y zip"
  exit 1
fi

cd "$ROOT_DIR"
zip -r "$OUT" defense \
  -x "defense/_backup/*" \
  -x "defense/04_evidence/waveforms/*" || true

echo "Packed: $OUT"
