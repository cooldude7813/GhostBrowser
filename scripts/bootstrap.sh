#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "\${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# Chromium/depot_tools uses this shared Git mirror to avoid repeatedly
# downloading the same large Git objects on clean CI runners.
export GIT_CACHE_PATH="\${GIT_CACHE_PATH:-$ROOT/.ghost-git-cache}"
export CHROME_HEADLESS="\${CHROME_HEADLESS:-1}"

# The CI runner starts with a fresh working tree. The Git mirror is the
# persistent part; the Chromium checkout itself is intentionally not cached
# because it is far larger than the included GitHub cache budget.
if [[ ! -f "$ROOT/src/.gclient" || ! -f "$ROOT/src/.gclient_entries" ]]; then
  rm -rf "$ROOT/src"
  mkdir -p "$ROOT/src"
fi

if [[ ! -d "$ROOT/src/brave/.git" ]]; then
  git clone --depth=1 --filter=blob:none --no-tags \
    https://github.com/brave/brave-core.git "$ROOT/src/brave"
fi

cd "$ROOT/src/brave"
corepack enable
corepack install
pnpm config set store-dir "\${PNPM_STORE_DIR:-$ROOT/.pnpm-store}"
pnpm install --frozen-lockfile --prefer-offline

# A clean CI runner needs Brave's documented init flow because the Chromium
# working tree is not persisted. A genuinely initialized local checkout uses
# the much cheaper sync path.
if [[ -f "$ROOT/src/.gclient" && -f "$ROOT/src/.gclient_entries" ]]; then
  pnpm run sync --target_os=android --target_arch=arm
else
  pnpm run init --target_os=android --target_arch=arm
fi

cd "$ROOT"
echo "Brave/Chromium Android foundation initialized/synced."
