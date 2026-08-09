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
- Noticed the test tone plays in the MSE stream but the WebRTC stream is silent. WebRTC does not carry AAC audio, it wants Opus. Looking into having go2rtc transcode.
- Added the gate camera to Home Assistant. The go2rtc brand was not in the integration list, so used Generic Camera with `rtsp://kronk-gate.local:8554/gate`. go2rtc serves RTSP on 8554 automatically. Left still image URL and credentials blank, named it Gate. Steps in [home setup](home-setup.md).
- Audio over WebRTC worked fine inside Home Assistant. The silence was only in the browser stream page.
- The RTSP card in Home Assistant lags a few seconds. A WebRTC integration is the later latency fix.
- Configured the HomeKit Bridge camera settings: checked Gate as a native H.264 stream, since rpicam-vid outputs H.264 and the Pi 5 relays instead of transcoding, and checked Gate for audio. Steps in [home setup](home-setup.md).
- A second camera entity named Building Entrance showed up in the HomeKit Bridge list. Figuring out what it is.
- Redid the Apple Home setup from scratch. The Apple TV integration I had added in Home Assistant looped back through the HomeKit Bridge into Apple Home as ghost duplicates of the Apple TV. Removed the Apple TV integration from HA, removed the bridge from the Home app, and deleted all three HomeKit Bridge entries in HA.
- Skipped the bridged device triggers screen while pairing. The doorbell button is not wired yet.
- Added a fresh HomeKit Bridge meant to include only `camera.gate`. The include filter came in empty, so it exported everything and the bridge showed up as Manufacturer Person, serial `person.nizar`. Set the filter to just the camera and it registered properly.
- The camera pairs as its own accessory. Added it as a new service under the bridge, scanned its QR code, and the Gate feed is live in Apple Home on the iPhone.
- No audio in the Apple Home app. HomeKit wants Opus in an SRTP session, and HA transcodes mic audio only when the source track cooperates. The synthetic AAC tone likely gets dropped at that hop, so audio debugging waits for the real mic. If HA cannot do it, Scrypted reads go2rtc directly and handles HomeKit camera audio.

- The Gate camera in Apple Home offers recording profiles for home and away. That is HomeKit Secure Video. It needs iCloud+ and stores clips in Apple's cloud. Going with it: Apple archives, the Pi streams.
- The camera feed in Apple Home is slow. Apple Home does not do WebRTC. HomeKit streams over SRTP, and the extra hop through Home Assistant repackaging the stream adds seconds of startup and latency.
- Decided to move the camera lane to Scrypted. It reads go2rtc directly, serves HomeKit cameras near instantly, and handles HomeKit Secure Video and two-way audio. Home Assistant keeps the automations and the future lock entity.

Next: set up Scrypted, solder the headers on the Pi Zero, then the doorbell button, the relay, the mic, and the speaker.

## 2026-08-08: All parts bought

Everything for the first prototype is in. See [parts](parts.md) and the [bill](bill.csv).

Notes:

- The Pi Zero 2 W with pre-soldered header was out of stock. Bought headerless boards and separate headers. Soldering them is the first job.
- The Pi Zero's camera connector is smaller than standard, so it needs its own [camera cable](parts.md#gate-unit).
- The [NoIR camera](parts/camera.md) has no IR cut filter, so the gate camera works at night.
- The [buck converter](parts/buck-converter.md) will power the gate unit from a 12V supply.

Next: solder headers, flash SD cards, boot both Pis.
