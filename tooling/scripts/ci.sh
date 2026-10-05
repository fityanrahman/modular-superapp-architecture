#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TARGET="${1:-all}"

shared=(contracts core design_system)
modules=(modules/food modules/ride modules/wallet)
apps=(apps/consumer_app apps/food_dev_app apps/ride_dev_app apps/wallet_dev_app)

case "$TARGET" in
  all)     selected=("${shared[@]}" "${modules[@]}" "${apps[@]}") ;;
  shared)  selected=("${shared[@]}") ;;
  modules) selected=("${modules[@]}") ;;
  apps)    selected=("${apps[@]}") ;;
  *)
    echo "Unknown target: $TARGET"
    exit 2
    ;;
esac

failures=()
for relative in "${selected[@]}"; do
  echo ""
  echo "=== $relative ==="
  if ! (cd "$ROOT/$relative" && flutter pub get && flutter analyze && flutter test); then
    failures+=("$relative")
  fi
done

if [ ${#failures[@]} -gt 0 ]; then
  echo ""
  echo "Failures in: ${failures[*]}"
  exit 1
fi

echo ""
echo "All checks passed."
