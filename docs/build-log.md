# Build Log

A dated journal of the kronk build. Newest entries at the top.

Each entry records what was done, decisions made, problems hit, and lessons
learned — the good and the bad. This is a first hardware project, so expect
beginner mistakes documented honestly.

---

## 2026-08-08 — All parts acquired

Finished purchasing all the hardware for the first prototype. The full list
with specs and prices is in the [inventory](inventory.md) — **$464.70** total
across 20 line items.

Notes from the shopping phase:

- The **Raspberry Pi Zero 2 W with pre-soldered header was out of stock**, so
  I bought the headerless version and separate 40-pin 2.54mm headers. This
  means the first soldering job of the project will be soldering the GPIO
  headers on — which is also why a soldering iron is on the parts list.
- Bought **two** Pi Zero 2 Ws while they were available.
- Chose the **Camera Module 3 NoIR (original, not Wide)** — no IR-cut filter,
  so the gate camera can work in low light / at night.
- Bought a **Pi Zero camera cable** separately: the Pi Zero's camera connector
  is smaller than the standard CSI connector, and the cable that ships with
  the camera module doesn't fit it.
- The **12V→5V buck converter** is for powering the gate-side electronics from
  a single 12V supply near the gate.

Next up: solder the headers onto a Pi Zero 2 W, flash the SD cards, and get
both Pis booting.
