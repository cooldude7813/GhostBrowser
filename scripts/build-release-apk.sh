#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT/src/brave"

pnpm run build Release --target_os=android --target_arch=arm --target_android_output_format=apk
