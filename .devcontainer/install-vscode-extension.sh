#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
VSCODE_DIR="${WORKSPACE_DIR}/tanu-markdown/tmd-vscode"
VSIX_PATH="$(find "${VSCODE_DIR}" -maxdepth 1 -type f -name '*.vsix' -print -quit)"

if [[ -z "${VSIX_PATH}" ]]; then
  echo "The Tanu Markdown VSIX is missing; run bash .devcontainer/post-create.sh." >&2
  exit 1
fi

if [[ -z "${VSCODE_IPC_HOOK_CLI:-}" ]] || ! command -v code >/dev/null 2>&1; then
  echo "VS Code is not attached yet; extension installation is deferred."
  exit 0
fi

code --install-extension "${VSIX_PATH}" --force
