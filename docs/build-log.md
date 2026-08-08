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
- `kronk-gate` would not come up. The micro USB cables were bad. Swapped them, flashed again, and now it boots and SSH works.
- Installed the [NoIR camera](parts/camera.md) on `kronk-gate`. First time ever connecting a camera, and it was easy: open the connector latches, remove the standard cable, insert the Pi Zero cable, close the latches.
- Verified the sensor with `rpicam-hello --list-cameras`, which printed `imx708`. Took the first photo with `rpicam-still -o first-look.jpg` and pulled it to the Mac with `scp`.
- Streamed the camera with go2rtc: live video in the browser at `http://kronk-gate.local:1984`. Steps in [gate setup](gate-setup.md).
- The stream did not show at first. The config was named `go2rtc.yml`, which go2rtc ignores. Renamed it to `go2rtc.yaml` and it worked.
- Went to hook up the mic and found the micro USB cable will not do. It needs a micro USB male to USB-A female adapter (OTG). Buying a UGreen one next week on a business day.
- Meanwhile, installed ffmpeg and added a 440Hz test tone as a second source in [gate/go2rtc.yaml](../gate/go2rtc.yaml), next to the video.
- The stream looked laggy for a moment. Switched to the WebRTC stream and it is amazingly fast.
- Made go2rtc a systemd service with [gate/go2rtc.service](../gate/go2rtc.service) so it always runs. Enabled it, checked active (running), and the stream survives a reboot.

Next: buy the mic adapter and put the real mic in the stream.

## 2026-08-08: All parts bought

Everything for the first prototype is in. See [parts](parts.md) and the [bill](bill.csv).

Notes:

- The Pi Zero 2 W with pre-soldered header was out of stock. Bought headerless boards and separate headers. Soldering them is the first job.
- The Pi Zero's camera connector is smaller than standard, so it needs its own [camera cable](parts.md#gate-unit).
- The [NoIR camera](parts/camera.md) has no IR cut filter, so the gate camera works at night.
- The [buck converter](parts/buck-converter.md) will power the gate unit from a 12V supply.

Next: solder headers, flash SD cards, boot both Pis.
