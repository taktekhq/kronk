# kronk-gate daemon

Bridges the gate GPIO to MQTT.

| Event | Topic | Payload |
|---|---|---|
| Button press, GPIO27 | `kronk/doorbell` | `ding` |
| Unlock command | `kronk/lock/set` | `UNLOCK` |
| Lock state, retained | `kronk/lock/state` | `UNLOCKED`, then `LOCKED` after the 3s relay pulse on GPIO17 |
| Daemon state, retained | `kronk/status` | `online`, `offline` |

## Build

Tag `gate-v*`. The [release workflow](../.github/workflows/release-gate.yml) attaches `kronk-gate-arm64` to the GitHub Release.

Local cross compile:

```
GOOS=linux GOARCH=arm64 CGO_ENABLED=0 go build -trimpath -ldflags "-s -w" -o kronk-gate-arm64 .
```

## Deploy

Create `/home/nizarmah/kronk-gate.env` on the Pi:

```
KRONK_BROKER=tcp://homeassistant.local:1883
KRONK_MQTT_USER=kronk-gate
KRONK_MQTT_PASS=change-me
```

Copy the binary and unit, then enable:

```
scp kronk-gate-arm64 nizarmah@kronk-gate.local:kronk-gate
scp kronk-gate.service nizarmah@kronk-gate.local:
ssh nizarmah@kronk-gate.local
sudo mv kronk-gate.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now kronk-gate
```

Manual run instead of the service: [run.sh](run.sh) sources `~/kronk-gate.env` and execs the binary.

## Test

Home Assistant: Settings, Devices and services, MQTT, Configure, listen to `kronk/#`.

- Press the button: `kronk/doorbell` shows `ding`.
- Publish `UNLOCK` to `kronk/lock/set`: the relay clicks for 3s, `kronk/lock/state` shows `UNLOCKED` then `LOCKED`.
- Stop the service: `kronk/status` shows `offline`.
