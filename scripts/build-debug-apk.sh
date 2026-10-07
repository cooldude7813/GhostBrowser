#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT/src/brave"

export JAVA_OPTS="${JAVA_OPTS:--Xmx10G -Xms1G}"
pnpm run build Debug --target_os=android --target_arch=arm --target_android_output_format=apk

echo
echo "Look under src/out/android_Debug_arm/apks/ for the generated APK(s)."
