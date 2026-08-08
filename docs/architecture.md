# Architecture

> ⚠️ **Working plan.** Nothing here is built or verified yet. This document
> describes the current intent and will be corrected as the build progresses —
> see the [build log](build-log.md) for what has actually been done.

## Overview

kronk is split into two units connected over the home network:

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

Lives at the building gate, in a weather-protected enclosure (TBD).

| Function | Part | Notes |
|----------|------|-------|
| Compute | Raspberry Pi Zero 2 W | Headerless — GPIO header soldered on manually |
| Video | Camera Module 3 NoIR | No IR-cut filter, so it can see at night; connected via the Pi Zero camera cable (the Zero has a smaller CSI connector) |
| Doorbell | Metal push button, momentary, 12mm, LED ring | Stainless, waterproof; the 12V LED ring doubles as a "system is on" indicator |
| Audio in | USB 2.0 mini microphone | Plug-and-play on the Zero's USB port |
| Gate opener | 1-channel 5V relay | Switches the existing gate opener circuit; driven from a GPIO pin |
| Power | 12V supply (existing/TBD) + 12V→5V 3A buck converter | One 12V feed at the gate powers the button LED directly and the Pi through the buck converter |

## Indoor unit

Lives in the apartment.

| Function | Part | Notes |
|----------|------|-------|
| Compute | Raspberry Pi 5, 4GB | Powered by the official 27W USB-C supply, cooled by the official Active Cooler |
| Audio out | TDA7266 dual amplifier + 50mm 8Ω 3W speaker | Amp supports 3–18V; exact supply point TBD |
| Display / UI | **TBD** | Options: dedicated screen, web app on a phone, or both |
| Audio in | **TBD** | A second USB microphone will likely be needed for talking back |

## Open questions

Things not yet decided — answers will land here and in the build log:

- **Streaming stack**: how video and two-way audio get between the units
  (WebRTC seems like the natural fit, but nothing is chosen yet).
- **Indoor UI**: dedicated display vs. phone-based web UI vs. both.
- **Enclosures**: weatherproofing for the gate unit.
- **Wiring at the gate**: how the relay ties into the existing gate opener
  circuit, and where the 12V supply comes from.
- **Second Pi Zero 2 W**: spare, or a second indoor/gate unit later
  (e.g. for another tenant during multi-tenant testing).
- **Multi-tenant support**: out of scope for the first prototype; the system
  is being tested for one household first.
