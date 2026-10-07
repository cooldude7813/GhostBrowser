#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# Brave explicitly supports GIT_CACHE_PATH for reusing the Chromium/depot-tools
# git history between clean CI runners. Keep it configurable for local builds.
export GIT_CACHE_PATH="${GIT_CACHE_PATH:-${RUNNER_TEMP:-$ROOT/.cache}/ghost-git-cache}"
export GCLIENT_JOBS="${GCLIENT_JOBS:-12}"

if [[ ! -d src/brave/.git ]]; then
  mkdir -p src
  git clone https://github.com/brave/brave-core.git src/brave
fi

# Patch only the build helper so gclient sync can use controlled parallelism.
# We intentionally do NOT use --no-history because Brave documents that Chromium
# history is required for its patching workflow.
UTIL_JS="$ROOT/src/brave/build/commands/lib/util.js"
python3 - "$UTIL_JS" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])
text = path.read_text()
needle = """  runGclient: (args, options = {}, gclientFile = config.gclientFile) => {
    if (config.gclientVerbose) {
      args.push('--verbose')
    }
"""
replacement = """  runGclient: (args, options = {}, gclientFile = config.gclientFile) => {
    if (
      process.env.GCLIENT_JOBS
      && args[0] === 'sync'
      && !args.some((arg) => arg === '--jobs' || arg.startsWith('--jobs='))
    ) {
      args.push(`--jobs=${process.env.GCLIENT_JOBS}`)
    }

    if (config.gclientVerbose) {
      args.push('--verbose')
    }
"""
if needle not in text:
    raise SystemExit("Expected Brave runGclient anchor was not found; refusing to patch an unknown version.")
if replacement not in text:
    text = text.replace(needle, replacement, 1)
    path.write_text(text)
PY

cd src/brave
corepack enable || true
pnpm config set store-dir "${PNPM_STORE_DIR:-$ROOT/.pnpm-store}"
pnpm install
pnpm run init --target_os=android --target_arch=arm

cd "$ROOT"
echo "Brave/Chromium Android foundation initialized."
