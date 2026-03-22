#!/bin/zsh
set -euo pipefail

REPO="$HOME/github/openclaw-agent-monitor"
PKG="$REPO/packages/gateway-watchdog"
STATE_DIR="$HOME/.openclaw/state/gateway-watchdog"
LOG_DIR="$HOME/.openclaw/logs"
mkdir -p "$STATE_DIR" "$LOG_DIR"

rotate_log() {
  local file="$1"
  local max_bytes="$2"
  local keep="${3:-3}"
  [ -f "$file" ] || return 0
  local size
  size=$(stat -f%z "$file" 2>/dev/null || echo 0)
  [ "$size" -lt "$max_bytes" ] && return 0
  local i
  i=$keep
  while [ "$i" -gt 1 ]; do
    local prev=$((i - 1))
    [ -f "$file.$prev" ] && mv -f "$file.$prev" "$file.$i"
    i=$prev
  done
  mv -f "$file" "$file.1"
}

rotate_log "$LOG_DIR/gateway-watchdog.log" $((512 * 1024)) 3
rotate_log "$STATE_DIR/events.jsonl" $((512 * 1024)) 3

NODE_BIN="/opt/homebrew/bin/node"
if [ ! -x "$NODE_BIN" ]; then
  NODE_BIN="$(command -v node)"
fi

exec "$NODE_BIN" "$PKG/src/watchdog.mjs" check \
  >> "$LOG_DIR/gateway-watchdog.log" 2>&1
