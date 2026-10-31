#!/usr/bin/env bash
# Package the Roku channel into build/vibeos-launcher.zip
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$root/build"
out="$root/build/vibeos-launcher.zip"
rm -f "$out"
(cd "$root/roku-channel" && zip -r -9 "$out" manifest source components images config -x '*.DS_Store')
echo "Built $out"
