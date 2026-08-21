# kronk

DIY Raspberry Pi video intercom. Pull the lever, Kronk!

Someone rings the building gate. You see them, talk to them, and buzz them in from your home.

First hardware project, documented in public so anyone can build one.

## Docs

| Doc | Content |
|---|---|
| [Parts](docs/parts.md) | What you need, and what I got |
| [Bill](docs/bill.csv) | What I paid |
| [Gate setup](docs/gate-setup.md) | Setting up `kronk-gate`, step by step |
| [Home setup](docs/home-setup.md) | Setting up the Pi 5 with Home Assistant |
| [Build log](docs/build-log.md) | Progress journal |
| [Architecture](docs/architecture.md) | How it fits together |

## Status

The gate camera is live in Apple Home with audio, recording, and face recognition. The doorbell button and lock relay are on MQTT. Home Assistant entities, HomeKit, and the speaker are next.

## License

[MIT](LICENSE)
