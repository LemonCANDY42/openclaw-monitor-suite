#!/bin/zsh
set -euo pipefail

LABEL="ai.openclaw.gateway-watchdog"
PLIST_PATH="$HOME/Library/LaunchAgents/${LABEL}.plist"
REPO="$HOME/github/openclaw-agent-monitor"
LOG_DIR="$HOME/.openclaw/logs"
mkdir -p "$HOME/Library/LaunchAgents" "$LOG_DIR"

cat > "$PLIST_PATH" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>${LABEL}</string>

    <key>ProgramArguments</key>
    <array>
      <string>/bin/zsh</string>
      <string>${REPO}/scripts/run-gateway-watchdog.sh</string>
    </array>

    <key>RunAtLoad</key>
    <true/>

    <key>StartInterval</key>
    <integer>180</integer>

    <key>StandardOutPath</key>
    <string>${LOG_DIR}/gateway-watchdog.launchd.out.log</string>

    <key>StandardErrorPath</key>
    <string>${LOG_DIR}/gateway-watchdog.launchd.err.log</string>

    <key>WorkingDirectory</key>
    <string>${REPO}</string>
  </dict>
</plist>
PLIST

launchctl bootout "gui/$(id -u)/$LABEL" >/dev/null 2>&1 || true
launchctl bootstrap "gui/$(id -u)" "$PLIST_PATH"
launchctl kickstart -k "gui/$(id -u)/$LABEL"

echo "Installed LaunchAgent: $PLIST_PATH"
echo "Label: $LABEL"
echo "Logs: $LOG_DIR/gateway-watchdog.log"
