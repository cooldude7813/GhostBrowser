#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if [[ ! -d src/brave/.git ]]; then
  mkdir -p src
  git clone https://github.com/brave/brave-core.git src/brave
fi

cd src/brave
corepack enable || true
pnpm install
pnpm run init --target_os=android --target_arch=arm

cd "$ROOT"
echo "Brave/Chromium Android foundation initialized."
