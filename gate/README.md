# kronk-gate daemon

Bridges the gate GPIO to MQTT.

| Event | Topic | Payload |
|---|---|---|
| Button press, GPIO27 | `kronk/doorbell` | `ding` |
| Unlock command | `kronk/lock/set` | `UNLOCK` |
| Lock state, retained | `kronk/lock/state` | `UNLOCKED`, then `LOCKED` after the 3s relay pulse on GPIO17 |
| Daemon state, retained | `kronk/status` | `online`, `offline` |

Retained messages on `kronk/lock/set` are ignored and cleared. A retained `UNLOCK` would replay on every reconnect. Publish commands without the retain flag.

## Build

Tag `gate-v*`. The [release workflow](../.github/workflows/release-gate.yml) attaches `kronk-gate-arm64` to the GitHub Release.

Local cross compile:

```
GOOS=linux GOARCH=arm64 CGO_ENABLED=0 go build -trimpath -ldflags "-s -w" -o kronk-gate-arm64 .
```

## Deploy

Create `/home/nizarmah/kronk-gate.env` on the Pi. Single-quote the values, no single quotes inside.

```
KRONK_BROKER='tcp://homeassistant.local:1883'
KRONK_MQTT_USER='kronk-gate'
KRONK_MQTT_PASS='change-me'
```

The daemon resolves `.local` names itself, one mDNS query per connect attempt. The static build cannot use the system resolver, so a plain hostname lookup would die with `no such host`.

It holds the MQTT password, keep it owner-only:

```
chmod 600 ~/kronk-gate.env
```

Download the release binary and unit on the Pi, then enable:

```
curl -Lo kronk-gate https://github.com/taktekhq/kronk/releases/latest/download/kronk-gate-arm64
curl -LO https://raw.githubusercontent.com/taktekhq/kronk/main/gate/kronk-gate.service
chmod +x kronk-gate
sudo mv kronk-gate.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now kronk-gate
```

Upgrading: `sudo systemctl stop kronk-gate` first. Writing into the running binary fails with `Text file busy`. Curl, then start the service again.

Or scp a [local build](#build):

```
chmod +x kronk-gate-arm64
scp kronk-gate-arm64 nizarmah@kronk-gate.local:kronk-gate
scp kronk-gate.service nizarmah@kronk-gate.local:
ssh nizarmah@kronk-gate.local
sudo mv kronk-gate.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now kronk-gate
```

Manual run instead of the service:

```
set -a; . ~/kronk-gate.env; set +a; ~/kronk-gate
```

## Test

Home Assistant: Settings, Devices and services, MQTT, Configure, listen to `kronk/#`.

- Press the button: `kronk/doorbell` shows `ding`.
- Publish `UNLOCK` to `kronk/lock/set`, retain unchecked: the relay clicks for 3s, `kronk/lock/state` shows `UNLOCKED` then `LOCKED`.
- Stop the service: `kronk/status` shows `offline`.
