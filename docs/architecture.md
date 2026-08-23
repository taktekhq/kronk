# Architecture

Working plan, partially built. The [build log](build-log.md) tracks reality.

```
        BUILDING GATE                          APARTMENT
┌─────────────────────────────┐      ┌───────────────────────────────┐
│  Gate unit                  │      │  Indoor unit                  │
│                             │      │                               │
│  Raspberry Pi Zero 2 W      │ WiFi │  Raspberry Pi 5 (4GB)         │
│   ├─ Camera Module 3 NoIR   │◄────►│   ├─ Home Assistant           │
│   ├─ USB mini microphone    │      │   └─ Scrypted                 │
│   ├─ TDA7266 amp + speaker  │      │                               │
│   ├─ Doorbell push button   │      │  iPhone + Apple TV hub        │
│   ├─ Relay → gate opener    │      │   └─ Apple Home               │
│   └─ 12V→5V buck converter  │      │                               │
└─────────────────────────────┘      └───────────────────────────────┘
```

## Software

- `kronk-gate` streams camera video and mic audio with [go2rtc](https://github.com/AlexxIT/go2rtc). Setup in [gate setup](gate-setup.md).
- The Pi 5 runs Home Assistant. Setup in [home setup](home-setup.md).
- Scrypted, a Home Assistant add-on, pulls the gate stream over RTSP and serves the camera to Apple Home as its own accessory. The camera does not go through Home Assistant.
- The HomeKit Bridge exposes the lock to Apple Home. The doorbell rings through Scrypted, a video doorbell on the camera.
- An Apple TV is the Home hub, which enables access over the internet.
- UI: the Apple Home app.
- Recording: HomeKit Secure Video with iCloud+. Apple archives, the Pi streams. OpenCV motion detection in Scrypted gates it.
- Talk-back path: the Home app's microphone, Scrypted's intercom, the go2rtc backchannel over RTSP, then `aplay` and the amp at the gate. Setup in [gate setup](gate-setup.md).
- Doorbell and lock path: gate GPIO, MQTT, then Home Assistant for the lock and Scrypted for the ring. The GPIO to MQTT leg is the [`kronk-gate` daemon](../gate/README.md).

## Gate unit

Hostname: `kronk-gate`.

| Function | Part |
|---|---|
| Compute | [Pi Zero 2 W](parts.md#gate-unit) |
| Video | [Camera Module 3 NoIR](parts/camera.md) |
| Doorbell | [Push button with LED ring](parts/push-button.md) on GPIO27 |
| Audio in | [USB mini microphone](parts/microphone.md) |
| Audio out | PWM on GPIO12, filter, [TDA7266 amp](parts/amplifier.md) + [50mm speaker](parts/speaker.md) |
| Gate opener | [5V relay](parts/relay.md) on GPIO17 |
| Power | 12V feed, [buck converter](parts/buck-converter.md) to 5V |

## Indoor unit

| Function | Part |
|---|---|
| Compute | Pi 5 with [27W PSU](parts/power-supply.md) and [Active Cooler](parts/active-cooler.md) |
| Display / UI | Apple Home app via HomeKit |

## Open questions

- Two-way audio: the gate speaker chain is designed and the go2rtc backchannel is configured, but nothing is wired or tested, and the Scrypted hop that carries HomeKit's microphone to it is unproven.
- Remote viewing through the Apple TV hub is slow, poor over cellular. Candidate fix: a low bandwidth substream in Scrypted.
- Gate unit enclosure and weatherproofing.
- How the relay wires into the existing gate opener, and where the 12V comes from.
- The second Pi Zero 2 W: spare, or a second unit later.
- The building's existing wired doorbell has a button per floor. Tap it for the floors, or add a separate board. Needs a voltage measurement first, those bells often run 8 to 12V AC.
- Multi-tenant support. Out of scope for the first prototype.
