# Operator Quickstart

Use this when you want the fastest safe check of the deployed lite watcher on Kenny's Mac.

## Core paths

- Repo: `~/github/openclaw-agent-monitor`
- Watcher package: `~/github/openclaw-agent-monitor/packages/lite-watcher`
- Health check script: `~/github/openclaw-agent-monitor/scripts/check-lite-watcher-health.sh`
- LaunchAgent label: `ai.openclaw.lite-watcher`
- LaunchAgent plist: `~/Library/LaunchAgents/ai.openclaw.lite-watcher.plist`
- Runtime state: `~/.openclaw/state/lite-watcher/`
- Runtime logs: `~/.openclaw/logs/openclaw-lite-watcher.log`

## 30-second health check

Run:

```bash
~/github/openclaw-agent-monitor/scripts/check-lite-watcher-health.sh
```

What you want to see:

- `launchAgent.plistExists = true`
- `launchAgent.loaded = true`
- `watcher.reportExists = true`
- `watcher.stateExists = true`
- `watcher.reportAgeSeconds` is reasonably fresh
- `autoResumeLite.enabled = false` (current safe default)
- `telegramDenied = true`
- `feishuDenied = true`

## Read the latest watcher result

```bash
cat ~/.openclaw/state/lite-watcher/last-report.json
```

Important fields:

- `signals`
- `incidents`
- `proposedActions`
- `humanSummary`

## Read the current watcher state

```bash
cat ~/.openclaw/state/lite-watcher/watcher-state.json
```

Important fields:

- `cooldowns`
- `lastReportMeta`
- `lastGood`
- `logCursors`

## Check launchd directly

```bash
launchctl print gui/$(id -u)/ai.openclaw.lite-watcher | sed -n '1,120p'
```

A periodic LaunchAgent may show `state = not running` between intervals. That is normal if:

- `last exit code = 0`
- the watcher report keeps updating

## Safe reload of the watcher service only

Use this only if the watcher itself is missing, unloaded, or clearly stale.

```bash
cp "$HOME/github/openclaw-agent-monitor/scripts/ai.openclaw.lite-watcher.plist" "$HOME/Library/LaunchAgents/ai.openclaw.lite-watcher.plist"
launchctl bootout "gui/$(id -u)"/ai.openclaw.lite-watcher >/dev/null 2>&1 || true
launchctl bootstrap "gui/$(id -u)" "$HOME/Library/LaunchAgents/ai.openclaw.lite-watcher.plist"
launchctl kickstart -k "gui/$(id -u)"/ai.openclaw.lite-watcher
```

Then re-run the 30-second health check.

## Current interpretation rules

- `feishu_status_path_mismatch` means Feishu summary/root status disagrees with account-level probe state.
- Treat it as a **diagnostic mismatch**, not a confirmed outage, unless stronger evidence appears.
- Do not restart OpenClaw or rewrite config just because this signal exists.
- The watcher is meant to be deterministic and read-only by default.

## Current safe posture for `auto-resume-lite`

- keep it scoped away from direct human chat
- current deny prefixes should include:
  - `agent:main:telegram:`
  - `agent:main:feishu:`
- if someone wants to broaden that scope, ask Kenny first
