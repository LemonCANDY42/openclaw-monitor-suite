# Gateway Watchdog Ops Reference

## Runtime pieces

- Project root: `~/github/openclaw-agent-monitor`
- Package root: `~/github/openclaw-agent-monitor/packages/gateway-watchdog`
- Service under watch: `ai.openclaw.gateway`
- Companion LaunchAgent: `ai.openclaw.gateway-watchdog`
- Watchdog script: `packages/gateway-watchdog/src/watchdog.mjs`
- Install helper: `scripts/install-gateway-watchdog.sh`
- Uninstall helper: `scripts/uninstall-gateway-watchdog.sh`

## State and logs

- State dir: `~/.openclaw/state/gateway-watchdog/`
- Main state: `~/.openclaw/state/gateway-watchdog/state.json`
- Event log: `~/.openclaw/state/gateway-watchdog/events.jsonl`
- Suppression file: `~/.openclaw/state/gateway-watchdog/suppress.json`
- Stdout log: `~/.openclaw/logs/gateway-watchdog.log`
- Stderr log: `~/.openclaw/logs/gateway-watchdog.err.log`

## Automatic recovery gates

Recovery is attempted only when all gates pass:

1. watchdog is not suppressed
2. gateway service is still loaded
3. recent planned restart grace window has expired
4. gateway runtime appears running
5. RPC probe is not healthy
6. gateway port is not actually listening
7. suspect classification repeats enough times
8. cooldown and retry budget still allow another recovery

## Retry controls

Current defaults inside `packages/gateway-watchdog/src/watchdog.mjs`:

- suspect threshold: 3 consecutive checks
- check interval: 180 seconds (LaunchAgent StartInterval)
- planned restart grace: 6 minutes
- minimum gap between recoveries: 15 minutes
- maximum recoveries per hour: 2
- maximum recoveries per day: 4

## Recovery action

Current recovery path:

1. `launchctl bootout gui/$UID/ai.openclaw.gateway`
2. short delay
3. `openclaw gateway start`
4. verify health repeatedly

## Notes

This project intentionally does **not** use an in-gateway plugin for recovery logic, because that would fail together with the gateway.
