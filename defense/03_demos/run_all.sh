#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

if [ -x "$ROOT_DIR/scripts/env_check.sh" ]; then
  echo "[1/4] env_check"
  "$ROOT_DIR/scripts/env_check.sh" || true
else
  echo "[1/4] env_check: SKIP (scripts/env_check.sh not found)"
fi

run_step() {
  local name="$1"
  local dir="$2"
  echo "[step] ${name}"
  if [ ! -d "$dir" ]; then
    echo "SKIP: ${dir} not found"
    return 0
  fi
  if [ -x "$dir/run.sh" ]; then
    (cd "$dir" && ./run.sh)
    echo "DONE: ${name} (run.sh)"
    return 0
  fi
  if [ -f "$dir/Makefile" ]; then
    if make -C "$dir" -n sim >/dev/null 2>&1; then
      make -C "$dir" sim
      echo "DONE: ${name} (make sim)"
      return 0
    fi
    if make -C "$dir" -n run >/dev/null 2>&1; then
      make -C "$dir" run
      echo "DONE: ${name} (make run)"
      return 0
    fi
    if make -C "$dir" -n sta >/dev/null 2>&1; then
      make -C "$dir" sta
      echo "DONE: ${name} (make sta)"
      return 0
    fi
  fi
  echo "SKIP: no runnable target in ${dir}"
}

run_step "verilator_nvboard" "$ROOT_DIR/tasks/verilator_nvboard"
run_step "pa1" "$ROOT_DIR/tasks/pa1"
run_step "sta" "$ROOT_DIR/tasks/sta"

echo "DONE: all steps"
echo "Evidence goes to $ROOT_DIR/defense/04_evidence/*"
