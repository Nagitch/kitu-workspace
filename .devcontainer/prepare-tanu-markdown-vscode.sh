#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
TANU_DIR="${WORKSPACE_DIR}/tanu-markdown"
VSCODE_DIR="${TANU_DIR}/tmd-vscode"
TMD_BINARY="${TANU_DIR}/target/debug/tmd"

if [[ ! -f "${TANU_DIR}/Cargo.toml" || ! -f "${VSCODE_DIR}/package.json" ]]; then
  echo "tanu-markdown is not initialized; run git submodule update --init --recursive." >&2
  exit 1
fi

cargo build --locked --manifest-path "${TANU_DIR}/Cargo.toml" -p tmd-cli
npm run compile --prefix "${VSCODE_DIR}"

install -D -m 0755 "${TMD_BINARY}" /home/vscode/.local/bin/tmd
install -D -m 0755 "${TMD_BINARY}" "${VSCODE_DIR}/bin/tmd"

"${TMD_BINARY}" validate "${TANU_DIR}/tmd-sample/sample.tmd"
echo "Tanu Markdown VS Code development build is ready."
