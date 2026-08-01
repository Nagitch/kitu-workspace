#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
TANU_DIR="${WORKSPACE_DIR}/tanu-markdown"
VSCODE_DIR="${TANU_DIR}/tmd-vscode"

if [[ ! -f "${TANU_DIR}/Cargo.toml" || ! -f "${VSCODE_DIR}/package.json" ]]; then
  echo "tanu-markdown is not initialized; run git submodule update --init --recursive." >&2
  exit 1
fi

rustup show
cargo --version
node --version
npm --version

cargo install \
  --locked \
  --force \
  --root /home/vscode/.local \
  --path "${TANU_DIR}/tmd-cli"

if [[ -f "${VSCODE_DIR}/package-lock.json" ]]; then
  npm ci --prefix "${VSCODE_DIR}"
else
  npm install --prefix "${VSCODE_DIR}" --no-package-lock
fi

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
