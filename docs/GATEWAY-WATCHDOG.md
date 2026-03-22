# Gateway Watchdog

Conservative companion watchdog for `ai.openclaw.gateway`.

## Purpose

This watchdog covers the narrow fake-alive failure mode where:

- launchd still thinks the gateway service is running
- `openclaw gateway status` reports `Runtime: running`
- RPC probe is unhealthy
- the gateway port is not actually listening

## Guardrails

It should not intervene when:

- the gateway service was intentionally stopped or unloaded
- the service is in a recent planned restart window
- a suppression window is active
- evidence is too weak or too recent
- retry budget is exhausted

## Current thresholds

- check interval: 180 seconds
- suspect threshold: 3 consecutive checks
- planned restart grace: 6 minutes
- minimum gap between recoveries: 15 minutes
- maximum recoveries per hour: 2
- maximum recoveries per day: 4

## Runtime paths

- state: `~/.openclaw/state/gateway-watchdog/`
- events: `~/.openclaw/state/gateway-watchdog/events.jsonl`
- main log: `~/.openclaw/logs/gateway-watchdog.log`
- launchd stdout: `~/.openclaw/logs/gateway-watchdog.launchd.out.log`
- launchd stderr: `~/.openclaw/logs/gateway-watchdog.launchd.err.log`

## Commands

Inspect:

```bash
~/github/openclaw-agent-monitor/scripts/check-gateway-watchdog-health.sh
```

Install/reinstall:

```bash
~/github/openclaw-agent-monitor/scripts/install-gateway-watchdog.sh
```

Uninstall:

```bash
~/github/openclaw-agent-monitor/scripts/uninstall-gateway-watchdog.sh
```

Suppress during maintenance:

```bash
cd ~/github/openclaw-agent-monitor/packages/gateway-watchdog
node src/watchdog.mjs suppress --minutes 15 --reason maintenance
```

Clear suppression:

```bash
cd ~/github/openclaw-agent-monitor/packages/gateway-watchdog
node src/watchdog.mjs unsuppress
```
