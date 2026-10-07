#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "== Ghost Browser Android/Chromium build environment =="

for tool in git python3 java node; do
  command -v "$tool" >/dev/null || { echo "Missing required tool: $tool"; exit 1; }
done

JAVA_MAJOR="$(java -version 2>&1 | awk -F'[".]' '/version/ {print $2; exit}')"
if [[ "$JAVA_MAJOR" != "17" ]]; then
  echo "WARNING: expected JDK 17; detected Java major version: $JAVA_MAJOR"
fi

NODE_MAJOR="$(node --version | sed 's/^v//' | cut -d. -f1)"
if [[ "$NODE_MAJOR" -lt 24 ]]; then
  echo "ERROR: Node.js 24+ is required."
  exit 1
fi

corepack enable
corepack prepare pnpm@latest --activate

if [[ ! -d "$ROOT/src/brave" ]]; then
  echo "Brave Core source is not present yet."
  echo "Run scripts/bootstrap.sh to fetch the real Brave/Chromium source."
  exit 0
fi

cd "$ROOT/src/brave"
echo "Installing Brave Core dependencies..."
pnpm install
echo "Synchronizing Chromium for Android..."
pnpm run sync --target_os=android

echo "Environment and Android source synchronization complete."
echo "Next step: run scripts/build-debug-apk.sh"
