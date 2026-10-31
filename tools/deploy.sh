#!/usr/bin/env bash
# Upload the zip to a Roku in developer mode (run from a machine on the same network).
# Usage: tools/deploy.sh <roku_ip> <dev_password>
set -euo pipefail
ip="${1:?usage: deploy.sh <roku_ip> <dev_password>}"
pw="${2:?usage: deploy.sh <roku_ip> <dev_password>}"
root="$(cd "$(dirname "$0")/.." && pwd)"
"$root/tools/build.sh"
curl --fail --digest -u "rokudev:$pw" -F "mysubmit=Install" \
     -F "archive=@$root/build/vibeos-launcher.zip" "http://$ip/plupload" | grep -iE "install|success|error|fail" || true
