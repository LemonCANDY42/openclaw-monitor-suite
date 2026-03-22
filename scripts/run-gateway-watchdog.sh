#!/bin/zsh
set -euo pipefail

REPO="$HOME/github/openclaw-agent-monitor"
PKG="$REPO/packages/gateway-watchdog"
STATE_DIR="$HOME/.openclaw/state/gateway-watchdog"
LOG_DIR="$HOME/.openclaw/logs"
mkdir -p "$STATE_DIR" "$LOG_DIR"

NODE_BIN="/opt/homebrew/bin/node"
if [ ! -x "$NODE_BIN" ]; then
  NODE_BIN="$(command -v node)"
fi

exec "$NODE_BIN" "$PKG/src/watchdog.mjs" check \
  >> "$LOG_DIR/gateway-watchdog.log" 2>&1
