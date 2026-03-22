---
name: gateway-watchdog-deploy
description: Deploy, inspect, suppress, unsuppress, or uninstall the dedicated OpenClaw gateway companion watchdog from the `openclaw-agent-monitor` monitor suite. Use when diagnosing or hardening against the specific fake-alive failure mode where `openclaw gateway status` shows the runtime as running but the RPC probe fails, or when an agent needs to manage the `ai.openclaw.gateway-watchdog` LaunchAgent and its state/log files.
---

# Gateway Watchdog Deploy

Use this skill to manage the dedicated companion watchdog for `ai.openclaw.gateway`.

## Core rule

Do **not** re-implement the watchdog ad hoc.

Use the existing monitor suite repo at:

- `~/github/openclaw-agent-monitor`

Use the package/runtime at:

- `~/github/openclaw-agent-monitor/packages/gateway-watchdog`

The watchdog is intentionally **outside** the gateway process, because a plugin/cron/heartbeat running inside the gateway cannot reliably recover a stalled gateway.

## What this watchdog is for

Target only the narrow fake-alive case:

- launchd still thinks `ai.openclaw.gateway` is running
- `openclaw gateway status` reports `Runtime: running`
- RPC probe fails
- the gateway port is not actually listening

It should stay conservative and avoid reviving intentionally stopped services.

## Quick commands

Run from the project root:

```bash
cd ~/github/openclaw-agent-monitor/packages/gateway-watchdog
npm run status
npm run check
node src/watchdog.mjs suppress --minutes 15 --reason maintenance
node src/watchdog.mjs unsuppress
~/github/openclaw-agent-monitor/scripts/install-gateway-watchdog.sh
~/github/openclaw-agent-monitor/scripts/uninstall-gateway-watchdog.sh
```

## Workflow

### 1. Inspect

Check:

- `npm run status`
- `launchctl print gui/$UID/ai.openclaw.gateway-watchdog`
- `launchctl print gui/$UID/ai.openclaw.gateway`
- `tail -n 100 ~/.openclaw/logs/gateway-watchdog.log`
- `tail -n 100 ~/.openclaw/logs/gateway.log`

### 2. Decide

Use the watchdog only when the service should normally be up.

If the user intentionally stopped or unloaded the gateway service, keep the watchdog idle.

### 3. Suppress when needed

Before maintenance or risky gateway work, temporarily suppress watchdog action:

```bash
cd ~/github/openclaw-agent-monitor/packages/gateway-watchdog
node src/watchdog.mjs suppress --minutes 15 --reason maintenance
```

Clear suppression after maintenance:

```bash
cd ~/github/openclaw-agent-monitor/packages/gateway-watchdog
node src/watchdog.mjs unsuppress
```

### 4. Install or reinstall

```bash
~/github/openclaw-agent-monitor/scripts/install-gateway-watchdog.sh
```

### 5. Uninstall

```bash
~/github/openclaw-agent-monitor/scripts/uninstall-gateway-watchdog.sh
```

## Files and paths

See `references/ops.md` for the runtime paths, decision rules, and recovery policy.
