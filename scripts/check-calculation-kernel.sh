#!/usr/bin/env bash
set -euo pipefail

workspace_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
kernel_revision=$(git -C "$workspace_root/openformula-kernel" rev-parse HEAD)

manifests=(
  "$workspace_root/tanu-markdown/Cargo.toml"
  "$workspace_root/tsq1/Cargo.toml"
  "$workspace_root/kitu-logic-processor/Cargo.toml"
)

for manifest in "${manifests[@]}"; do
  if ! rg -q "openformula-kernel = .*rev = \"$kernel_revision\"" "$manifest"; then
    printf 'kernel revision mismatch: %s must pin %s\n' "$manifest" "$kernel_revision" >&2
    exit 1
  fi
done

printf 'all consumers pin openformula-kernel %s\n' "$kernel_revision"
