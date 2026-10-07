#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# Reuse Chromium/depot_tools Git objects between clean CI runners.
export GIT_CACHE_PATH="${GIT_CACHE_PATH:-${RUNNER_TEMP:-$ROOT/.cache}/ghost-git-cache}"
export GCLIENT_JOBS="${GCLIENT_JOBS:-12}"

if [[ ! -d src/brave/.git ]]; then
  mkdir -p src
  # Brave Core itself does not need a full history for the build. Keep this
  # checkout small; Chromium's own history is handled separately by GIT_CACHE_PATH.
  git clone --depth=1 --filter=blob:none --no-tags https://github.com/brave/brave-core.git src/brave
fi

cd src/brave
corepack enable || true
# Use the version declared by Brave Core instead of floating to whatever
# pnpm@latest happens to be on the runner.
corepack install 2>/dev/null || true
pnpm config set store-dir "${PNPM_STORE_DIR:-$ROOT/.pnpm-store}"
pnpm install --frozen-lockfile --prefer-offline

# The first foundation checkout must use Brave's documented init flow.
# Later workflows should use pnpm run sync when the Chromium tree is already
# initialized; do not force --init unless the dependency revision actually changed.
if [[ ! -d "$ROOT/src/.git" ]]; then
  pnpm run init --target_os=android --target_arch=arm
else
  pnpm run sync --target_os=android
fi

cd "$ROOT"
echo "Brave/Chromium Android foundation initialized/synced."
