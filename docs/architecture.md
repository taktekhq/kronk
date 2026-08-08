# Architecture

Working plan. Nothing is built yet. The [build log](build-log.md) tracks reality.

```
        BUILDING GATE                          APARTMENT
┌─────────────────────────────┐      ┌───────────────────────────────┐
│  Gate unit                  │      │  Indoor unit                  │
│                             │      │                               │
│  Raspberry Pi Zero 2 W      │ WiFi │  Raspberry Pi 5 (4GB)         │
│   ├─ Camera Module 3 NoIR   │◄────►│   ├─ Display / UI (TBD)       │
│   ├─ USB mini microphone    │      │   ├─ TDA7266 amp + speaker    │
│   ├─ Doorbell push button   │      │   └─ Microphone (TBD)         │
│   ├─ Relay → gate opener    │      │                               │
│   └─ 12V→5V buck converter  │      │                               │
└─────────────────────────────┘      └───────────────────────────────┘
```

## Gate unit

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
| Display / UI | TBD |
| Audio in | TBD |

## Open questions

- Streaming stack for video and two-way audio. WebRTC is the likely pick.
- Indoor UI: dedicated screen, phone web app, or both.
- Gate unit enclosure and weatherproofing.
- How the relay wires into the existing gate opener, and where the 12V comes from.
- The second Pi Zero 2 W: spare, or a second unit later.
- Multi-tenant support. Out of scope for the first prototype.
