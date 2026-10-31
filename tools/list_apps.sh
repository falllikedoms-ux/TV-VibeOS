#!/usr/bin/env bash
# List installed channel IDs on a Roku (ECP). Use it to fill in config/channels.json.
# Usage: tools/list_apps.sh <roku_ip>
set -euo pipefail
ip="${1:?usage: list_apps.sh <roku_ip>}"
curl -s "http://$ip:8060/query/apps" | sed -E 's/<app id="([^"]+)"[^>]*>([^<]*)<\/app>/\1\t\2/' | grep -E '^[0-9a-zA-Z.]+\s' || true
