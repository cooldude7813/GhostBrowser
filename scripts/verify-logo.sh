#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOGO="$ROOT/branding/ghost-browser-logo.png"

[[ -s "$LOGO" ]] || { echo "ERROR: canonical Ghost Browser logo is missing"; exit 1; }

python3 - "$LOGO" <<'PY'
from PIL import Image
import sys
p=sys.argv[1]
im=Image.open(p)
if im.size[0] != im.size[1]:
    raise SystemExit("ERROR: Ghost Browser logo must remain square")
print(f"Ghost Browser logo OK: {im.size[0]}x{im.size[1]} {im.mode}")
PY
