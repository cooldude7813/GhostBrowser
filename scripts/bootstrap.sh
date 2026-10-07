#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "\${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

export GIT_CACHE_PATH="\${GIT_CACHE_PATH:-$ROOT/.ghost-git-cache}"
export CHROME_HEADLESS="\${CHROME_HEADLESS:-1}"

if [[ ! -f "$ROOT/.gclient" || ! -f "$ROOT/src/.gclient_entries" ]]; then
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

if [[ -f "$ROOT/.gclient" && -d "$ROOT/src/.git" ]]; then
  pnpm run sync --target_os=android --target_arch=arm
else
  pnpm run init --target_os=android --target_arch=arm
fi

cd "$ROOT"
echo "Brave/Chromium Android foundation initialized/synced."
