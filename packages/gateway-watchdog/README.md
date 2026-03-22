# openclaw-gateway-watchdog

A narrow companion watchdog for the specific case where `ai.openclaw.gateway` looks alive to launchd but the Gateway RPC is unhealthy.

## Purpose

This package exists for the fake-alive case:

- launchd still sees the gateway service
- `openclaw gateway status` shows `Runtime: running`
- RPC probe is not healthy
- gateway port is not actually listening

## Design stance

- Conservative by default
- Outside the gateway process
- Respect planned maintenance and suppression windows
- Avoid infinite retries
- Recover only after repeated strong evidence

## Runtime paths

- state: `~/.openclaw/state/gateway-watchdog/`
- logs: `~/.openclaw/logs/gateway-watchdog.log`
- stderr: `~/.openclaw/logs/gateway-watchdog.err.log`

## Commands

```bash
cd ~/github/openclaw-agent-monitor/packages/gateway-watchdog
npm run status
npm run check
```
