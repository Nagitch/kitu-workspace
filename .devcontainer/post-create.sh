#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
TANU_DIR="${WORKSPACE_DIR}/tanu-markdown"
VSCODE_DIR="${TANU_DIR}/tmd-vscode"
FRAMEWORK_DIR="${WORKSPACE_DIR}/kitu-logic-processor"
DEMO_DIR="${WORKSPACE_DIR}/kitu-unity-demo-game"

# Initialize and hydrate LFS independently for repositories that are already
# present. A partial clone can still be opened and repaired with
# `git submodule update --init --recursive` later. A present demo checkout
# must hydrate successfully because its Unity fixtures and native assets are
# required by the application setup.
if command -v git-lfs >/dev/null 2>&1; then
  for repository in "${WORKSPACE_DIR}" "${FRAMEWORK_DIR}" "${DEMO_DIR}"; do
    if [[ -d "${repository}" ]] && git -C "${repository}" rev-parse --git-dir >/dev/null 2>&1; then
      git -C "${repository}" lfs install --local
      if [[ -n "$(git -C "${repository}" lfs ls-files --name-only)" ]]; then
        if ! git -C "${repository}" lfs pull; then
          if [[ "${repository}" == "${DEMO_DIR}" ]]; then
            echo "Git LFS hydration failed for the present demo checkout: ${repository}" >&2
            exit 1
          fi
          echo "Warning: Git LFS hydration failed for ${repository}; repair it with git lfs pull." >&2
        else
          git -C "${repository}" lfs checkout
        fi
      fi
    fi
  done
fi

if [[ ! -f "${TANU_DIR}/Cargo.toml" || ! -f "${VSCODE_DIR}/package.json" ]]; then
  echo "tanu-markdown is not initialized; run git submodule update --init --recursive." >&2
  exit 1
fi

rustup show
cargo --version
node --version
npm --version

if [[ -f "${VSCODE_DIR}/package-lock.json" ]]; then
  npm ci --prefix "${VSCODE_DIR}"
else
  npm install --prefix "${VSCODE_DIR}" --no-package-lock
fi

bash "${SCRIPT_DIR}/prepare-tanu-markdown-vscode.sh"

if node -e 'const manifest = require(process.argv[1]); process.exit(manifest.scripts?.pack ? 0 : 1)' \
  "${VSCODE_DIR}/package.json"; then
  npm run pack --prefix "${VSCODE_DIR}"
else
  npm run compile --prefix "${VSCODE_DIR}"
  (
    cd "${VSCODE_DIR}"
    npm exec \
      --yes \
      --package @vscode/vsce@3.9.2 \
      -- vsce package --no-dependencies
  )
fi

VSIX_PATH="$(find "${VSCODE_DIR}" -maxdepth 1 -type f -name '*.vsix' -print -quit)"
if [[ -z "${VSIX_PATH}" ]]; then
  echo "The Tanu Markdown VSIX was not generated." >&2
  exit 1
fi

/home/vscode/.local/bin/tmd --version

echo "Generated Tanu Markdown VSIX: ${VSIX_PATH}"

if [[ -f "${DEMO_DIR}/tools/setup.py" && -f "${FRAMEWORK_DIR}/Cargo.toml" ]]; then
  echo "Preparing the Kitu Unity demo dependencies..."
  python3 "${DEMO_DIR}/tools/setup.py"
else
  echo "Kitu Unity demo is not initialized; run git submodule update --init --recursive when available."
fi
