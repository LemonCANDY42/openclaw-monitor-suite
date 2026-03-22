#!/bin/zsh
set -euo pipefail

REPO="$HOME/github/openclaw-agent-monitor"

"$REPO/scripts/install-gateway-watchdog.sh"

if [ -x "$REPO/scripts/run-lite-watcher.sh" ] && [ -f "$REPO/scripts/ai.openclaw.lite-watcher.plist" ]; then
  cp "$REPO/scripts/ai.openclaw.lite-watcher.plist" "$HOME/Library/LaunchAgents/ai.openclaw.lite-watcher.plist"
  launchctl bootout "gui/$(id -u)"/ai.openclaw.lite-watcher >/dev/null 2>&1 || true
  launchctl bootstrap "gui/$(id -u)" "$HOME/Library/LaunchAgents/ai.openclaw.lite-watcher.plist"
  launchctl kickstart -k "gui/$(id -u)"/ai.openclaw.lite-watcher
  echo "Installed LaunchAgent: $HOME/Library/LaunchAgents/ai.openclaw.lite-watcher.plist"
  echo "Label: ai.openclaw.lite-watcher"
fi

echo "Monitor suite install/reinstall complete."
