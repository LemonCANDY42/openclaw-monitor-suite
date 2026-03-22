#!/bin/zsh
set -euo pipefail

REPO="$HOME/github/openclaw-agent-monitor"
STATE_DIR="$HOME/.openclaw/state/gateway-watchdog"
LABEL="ai.openclaw.gateway-watchdog"

launchctl print "gui/$(id -u)/$LABEL" >/tmp/gateway-watchdog-launchctl.txt 2>/tmp/gateway-watchdog-launchctl.err || true
node "$REPO/packages/gateway-watchdog/src/watchdog.mjs" status
