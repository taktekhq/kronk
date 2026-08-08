# Architecture

Working plan, partially built. The [build log](build-log.md) tracks reality.

```
        BUILDING GATE                          APARTMENT
┌─────────────────────────────┐      ┌───────────────────────────────┐
│  Gate unit                  │      │  Indoor unit                  │
│                             │      │                               │
│  Raspberry Pi Zero 2 W      │ WiFi │  Raspberry Pi 5 (4GB)         │
│   ├─ Camera Module 3 NoIR   │◄────►│   ├─ Home Assistant           │
│   ├─ USB mini microphone    │      │   ├─ TDA7266 amp + speaker    │
│   ├─ Doorbell push button   │      │   └─ Microphone (TBD)         │
│   ├─ Relay → gate opener    │      │                               │
│   └─ 12V→5V buck converter  │      │                               │
└─────────────────────────────┘      └───────────────────────────────┘
```

## Software

- `kronk-gate` streams camera video with [go2rtc](https://github.com/AlexxIT/go2rtc). Setup in [gate setup](gate-setup.md).
- The Pi 5 runs Home Assistant and pulls the gate stream over RTSP as a Generic Camera. Setup in [home setup](home-setup.md).
- The HomeKit Bridge exposes it to Apple Home.
- An Apple TV is the Home hub, which enables access over the internet.
- UI: the Apple Home app.

## Gate unit

Hostname: `kronk-gate`.

| Function | Part |
|---|---|
| Compute | [Pi Zero 2 W](parts.md#gate-unit) |
| Video | [Camera Module 3 NoIR](parts/camera.md) |
| Doorbell | [Push button with LED ring](parts/push-button.md) |
| Audio in | [USB mini microphone](parts/microphone.md) |
| Gate opener | [5V relay](parts/relay.md) on a GPIO pin |
| Power | 12V feed, [buck converter](parts/buck-converter.md) to 5V |

## Indoor unit

| Function | Part |
|---|---|
| Compute | Pi 5 with [27W PSU](parts/power-supply.md) and [Active Cooler](parts/active-cooler.md) |
| Audio out | [TDA7266 amp](parts/amplifier.md) + [50mm speaker](parts/speaker.md) |
| Display / UI | Apple Home app via HomeKit |
| Audio in | TBD |

## Open questions

- Audio in Apple Home. HomeKit wants Opus over SRTP. Waiting on the real mic to debug. Scrypted is the fallback.
- Two-way audio.
- RTSP lag in the Home Assistant card. WebRTC is the likely fix.
- Gate unit enclosure and weatherproofing.
- How the relay wires into the existing gate opener, and where the 12V comes from.
- The second Pi Zero 2 W: spare, or a second unit later.
- Multi-tenant support. Out of scope for the first prototype.
