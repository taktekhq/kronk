# Build Log

Dated journal. Newest first.

## 2026-08-08: Pi 5 up, running Home Assistant

The indoor unit is alive.

- First shopping trip missed a few things: the soldering iron, the SD cards for the Pi Zeros, and the M-M and M-F jumpers. Went back the next day.
- Flashed the Pi 5 SD card with Home Assistant that night.
- Next day: installed the [Active Cooler](parts/active-cooler.md), plugged into router and power. First boot failed. The outlet was old and faulty and did not deliver enough power, so the setup broke halfway.
- Reflashed, switched to a different outlet and ethernet through a WiFi extender. Worked. Could watch status and logs during setup.
- Finished Home Assistant setup, updated the software, rebooted.
- Set up the Apple HomeKit Bridge and added it to Apple Home. Reset the Apple TV and set it up with my account. It became the Home hub automatically, which gives access to the home over the internet.
- Flashed the SD card for `kronk-gate`, the gate Pi Zero 2 W.

Next: set up `kronk-gate`.

## 2026-08-08: All parts bought

Everything for the first prototype is in. See [parts](parts.md) and the [bill](bill.csv).

Notes:

- The Pi Zero 2 W with pre-soldered header was out of stock. Bought headerless boards and separate headers. Soldering them is the first job.
- The Pi Zero's camera connector is smaller than standard, so it needs its own [camera cable](parts.md#gate-unit).
- The [NoIR camera](parts/camera.md) has no IR cut filter, so the gate camera works at night.
- The [buck converter](parts/buck-converter.md) will power the gate unit from a 12V supply.

Next: solder headers, flash SD cards, boot both Pis.
