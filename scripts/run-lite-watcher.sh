#!/bin/zsh
set -euo pipefail

REPO="$HOME/github/openclaw-agent-monitor"
PKG="$REPO/packages/lite-watcher"
STATE_DIR="$HOME/.openclaw/state/lite-watcher"
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

rotate_log "$LOG_DIR/openclaw-lite-watcher.log" $((512 * 1024)) 3

NODE_BIN="$HOME/.nvm/versions/node/v24.14.0/bin/node"
if [ ! -x "$NODE_BIN" ]; then
  NODE_BIN="$(command -v node)"
fi

exec "$NODE_BIN" "$PKG/src/watcher.mjs" check \
  --state "$STATE_DIR/watcher-state.json" \
  --report "$STATE_DIR/last-report.json" \
  --lock "$STATE_DIR/watcher.lock" \
  >> "$LOG_DIR/openclaw-lite-watcher.log" 2>&1
