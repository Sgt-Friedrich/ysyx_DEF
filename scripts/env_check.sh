#!/usr/bin/env bash
set -euo pipefail

missing=0

check_cmd() {
  local name="$1" cmd="$2" ver_cmd="$3" required="$4"
  if command -v "$cmd" >/dev/null 2>&1; then
    echo "$name: $(eval "$ver_cmd" 2>/dev/null | head -n 1)"
  else
    echo "$name: MISSING"
    if [ "$required" = "yes" ]; then
      missing=1
    fi
  fi
}

check_cmd git git "git --version" yes
check_cmd gcc gcc "gcc --version" yes
if command -v gcc >/dev/null 2>&1; then
  check_cmd g++ g++ "g++ --version" yes
else
  check_cmd g++ g++ "g++ --version" yes
fi
check_cmd make make "make --version" yes
check_cmd verilator verilator "verilator --version" no

if [ "$missing" -ne 0 ]; then
  echo "INSTALL_HINT: sudo apt-get install -y git gcc g++ make verilator"
  exit 1
fi
