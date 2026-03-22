#!/bin/zsh
set -euo pipefail

REPO="$HOME/github/openclaw-agent-monitor"

"$REPO/scripts/uninstall-gateway-watchdog.sh"
launchctl bootout "gui/$(id -u)"/ai.openclaw.lite-watcher >/dev/null 2>&1 || true
rm -f "$HOME/Library/LaunchAgents/ai.openclaw.lite-watcher.plist"
echo "Uninstalled LaunchAgent: $HOME/Library/LaunchAgents/ai.openclaw.lite-watcher.plist"

echo "Monitor suite uninstall complete."
