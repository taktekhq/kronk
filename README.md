# kronk

**DIY Raspberry Pi Video Intercom. Pull the lever, Kronk!**

kronk is a homemade video intercom for a building gate. When someone rings the
doorbell at the gate, you can see who it is, talk with them, and buzz the gate
open — all from inside your home.

This is my **first hardware project**, and I'm documenting everything in the
open: what I bought and what it cost, how I'm building it, what worked, and
what went wrong. If you want to build something similar — or just learn along
with me — everything you need should be in this repository.

## What it will do

- 📹 **See** — a camera at the gate shows you who's ringing
- 🎙️ **Talk** — two-way audio between the gate and the apartment
- 🔓 **Open** — a relay wired to the gate opener lets you buzz visitors in
- 🏠 **Multi-tenant later** — testing with one household first, with the goal
  of supporting the other tenants in the building eventually

## Status

🚧 **Early days.** All the hardware has been purchased (see the
[inventory](docs/inventory.md)) and the build is just getting started. Follow
the [build log](docs/build-log.md) for progress.

## Documentation

| Document | What's in it |
|----------|--------------|
| [docs/inventory.md](docs/inventory.md) | Every part purchased, with full specs, quantities, and prices — **$464.70** total so far |
| [docs/build-log.md](docs/build-log.md) | Dated journal of the build: what was done, what was learned, what went wrong |
| [docs/architecture.md](docs/architecture.md) | How the system fits together — the current working plan, updated as the design evolves |

## Hardware at a glance

The two main computers:

- **Raspberry Pi 5 (4GB)** — the indoor unit / brains
- **2× Raspberry Pi Zero 2 W** — the gate unit (plus a spare)

Key peripherals: Raspberry Pi Camera Module 3 NoIR (works in the dark),
USB mini microphone, TDA7266 stereo amplifier + 50mm speaker, a 5V relay to
drive the gate opener, a momentary push button with LED ring for the doorbell,
and a 12V→5V buck converter to power the gate unit. The full list with specs
and prices is in [docs/inventory.md](docs/inventory.md).

## Following along / contributing

This project is a learning exercise shared in public. Questions, suggestions,
and corrections are all welcome — open an issue. If you build your own, I'd
love to hear how it went.

## License

[MIT](LICENSE)
