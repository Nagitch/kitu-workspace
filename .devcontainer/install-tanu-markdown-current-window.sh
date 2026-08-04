#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
VSCODE_DIR="${WORKSPACE_DIR}/tanu-markdown/tmd-vscode"

if [[ -z "${VSCODE_IPC_HOOK_CLI:-}" ]] || ! command -v code >/dev/null 2>&1; then
  echo "Run this script from a VS Code task or integrated terminal in the attached Dev Container." >&2
  exit 1
fi

bash "${SCRIPT_DIR}/prepare-tanu-markdown-vscode.sh"
npm run pack --prefix "${VSCODE_DIR}"
bash "${SCRIPT_DIR}/install-vscode-extension.sh"

echo
echo "Tanu Markdown Editor was installed in the current Dev Container window."
echo "Run 'Developer: Reload Window', then open tanu-markdown/tmd-sample/sample.tmd."
