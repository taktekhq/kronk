# Build Log

Dated journal. Newest first.

## 2026-08-23: Speaker path designed, backchannel configured

- Moved the amp and speaker from the indoor unit to the gate in [architecture](architecture.md) and [parts](parts.md). The iPhone is the indoor handset, the missing half is a visitor hearing me.
- The Pi Zero 2 W has no audio jack and no DAC. Picked PWM through a passive filter over a USB sound card or an I2S DAC, it is the one that uses the TDA7266 already bought.
- `dtoverlay=audremap,pins_12_13` puts PWM audio on GPIO12 and GPIO13. No conflict with the relay on GPIO17 or the button on GPIO27. GPIO12 alone carries voice.
- Addressed the card by name, `plughw:CARD=Headphones,DEV=0`. The mic holds card 0.
- Took the filter values off the Pi's own audio output: 270Ω and 33nF, then 150Ω and 10nF, then 1µF to block DC into the amp. Not bought yet.
- Amp runs off the buck's 5V, not the Pi's 5V pin. 12V would drive the 3W speaker past its rating.
- Added `aplay` as a third source in [gate/go2rtc.yaml](../gate/go2rtc.yaml). `#backchannel=1` makes an `exec` source consume audio instead of producing it.
- Read go2rtc's source for two things the docs skip. The default backchannel codec is raw signed 16 bit little endian at 16kHz mono, so no `#audio=` is needed. The RTSP server advertises the incoming track only when the client URL carries `?backchannel=1`.
- The gate half tests without Apple Home: `POST /api/streams?dst=gate&src=ffmpeg:file.wav` on port 1984 plays out the speaker.
- Wrote the Scrypted hop into [home setup](home-setup.md), untested. A plain RTSP camera has no intercom, the ONVIF plugin provides it, and the write-ups that got it working set the RTSP parser to UDP, which fights the TCP the video needs.
- Nothing wired, nothing heard.

Next: buy the passives, build the filter, listen.

## 2026-08-23: Lock and doorbell in Apple Home

- Added the lock and doorbell event entities in `configuration.yaml`. Both live, `lock.gate` read the retained `LOCKED` from the broker.
- The HomeKit Bridge UI has no event domain, an event entity cannot be exposed as an accessory. Replaced the UI bridge with a YAML bridge, `linked_doorbell_sensor` hung the doorbell on the lock.
- The UI bridge and the YAML bridge both exposed the lock, two locks in Apple Home grouped into one accessory. Deleted the UI bridge, it carried nothing else.
- Moved the ring to Scrypted for video in the notification: MQTT plugin button subscribed to `kronk/doorbell`, Custom Doorbell Button extension on the camera, re-paired as a video doorbell.
- Three snags. The MQTT device connects with null credentials until the plugin restarts, credentials go on the device not the plugin. The doorbell button selection only registers when the extension starts, toggle it off and on. The button script must pulse the state back to false, the daemon sends no release.
- Dropped `linked_doorbell_sensor` from the YAML bridge, one ring per press.
- End state: unlock and ring in Apple Home, ring carries the camera snapshot. Press to notification runs about a second.

## 2026-08-22: MQTT live, gate daemon connected

- Installed the Mosquitto broker app on Home Assistant, created the `kronk-gate` user, added the MQTT integration.
- Deployed the daemon on `kronk-gate` from the `gate-v0.1.0` release, curl straight onto the Pi.
- First connect failed. The static binary skips mDNS, and the router's DNS knows no `.local` names.
- The daemon now resolves `.local` itself, one multicast query per connect attempt. Released as `gate-v0.1.1`.
- Upgrade gotcha: the running binary cannot be overwritten, `Text file busy`. Stop the service, curl, start.
- Daemon connected: `resolved homeassistant.local to 192.168.1.134`, then `connected`.

Next: listen test on `kronk/#`, the lock and doorbell entities, HomeKit Bridge.

## 2026-08-22: v5 printed, then plugged in, v10

- Printed v5, saddle upside down with no supports, pegs standing. Much better print, much better fit.
- It wobbles on the wall: the wall-side skirt hits the outlet's raised edge between the cube and the wall, which levers the saddle up and keeps the arm off the Cudy.
- v6: the wall-side skirt is gone, nothing extends wallward below the plate anymore. A 30mm boss under the plate drops into the round socket well on the cube's top face and keys the saddle laterally instead. Skirt stays on the left and room sides.
- v7, before printing v6: the boss became two solid prongs that plug into the cube's top socket, the one the saddle covers anyway, like a child blanking plug. The socket's contacts grip them, hold-down and lateral lock in one move. Solid plastic, no metal, ever.
- Removed the antenna notches, the splayed antennas never reach the arm.
- v8: the plug carries everything. The prongs got a round base that nests in the socket well like a real plug face. The Cudy foot is gone, the arm just cantilevers over it and ends at the board's edge. The skirt walls shrank to 4mm alignment guides and lost their tie slots.
- The v5 pegs sat loose in their sockets and the Pi lifted off with no resistance. v9 pegs are snap pins like the Pi active cooler's: a split runs the whole peg, the barbed tip squeezes through the board's hole and clicks open above it, the fatter split shaft squeezes snug into the socket. The round flange became a seat bar along the split so the halves stay thin and PLA flexes instead of snapping.
- Printed the v8 saddle and v9 pegs. The saddle plugs in, hole spacing and orientation confirmed, but it pulls out too easily: the prongs were 4.5 wide and reached only 8mm past the socket face. Real pins are 4.8 wide and engage 19mm, where the grip springs sit.
- v10 prongs match the European convention, 4.8 by 19, and lean 0.5mm toward each other like a Europlug's converging pins, the socket bends them straight and the springback grips.
- Measured the top socket well: 38 wide, 4 deep to the socket face, not the guessed 9. The base grew to 37.4 by 3.8, filling the well 0.2 shy of its floor, so the plate seats on the cube and the base bears just after. The prongs shortened to match the real depth.
- Tested the v9 pegs: snug in the saddle sockets and they click into the Pi's holes properly. One peg died to a too-hard squeeze, a spare took its place.
- Printed the v10 saddle, 16g, 40 minutes. Plugged it in: perfect fit, locked in. The full-size converging prongs grip in the socket, the base fills the well, the plate seats flat on the cube. The saddle is done.
- The snap pegs have a flaw: two of the Pi's four mounting holes are covered above, the barb has nowhere to click open, and forcing it breaks the peg. Both spares gone. The two open holes take the pegs perfectly, easy in and snug.
- Mounted the Pi on the saddle with the surviving pegs, power and ethernet connected. Everything holds. The power corner is live.
- Known issue, fix later: pegs that work on the covered holes. The plan is identical split expansion pins that grip inside the bore instead of clicking open above it.
- Correction, from the CAD screenshots: the Pi's holes were never covered and the pegs were never the problem. The hard "holes" were the saddle's peg sockets. The two sockets the arm's zip tie notches happened to cut open took pegs easily and held snug; the two whole sockets were too stiff, trapped air under the shaft, and broke pegs during insertion. The accident was the better design.
- v13: the sockets now run straight through the plate, open at the bottom, so the trapped air escapes below instead of fighting the shaft. The ring stays whole, all four sockets identical, and the shaft is shorter than the plate so nothing pokes out underneath. The zip tie notches are gone, the arm is a uniform rectangle, the plug is the only anchor.
- Made the pegs stronger: the split no longer runs through the shaft. A solid shaft takes the socket press, the split spans only the seat and pin where the barb needs its flex. One more peg died to the old air pocket during install, the Pi rides on three of four meanwhile.
- Lengthened the peg shafts from 2.9 to 3.7, the through sockets made the room: deeper seat, straighter peg, still 0.3 shy of the plate bottom.
- Saved the Bambu Studio project with both parts and the working settings.
- Printed v13: impossible to press in. Printed holes shrink, and the solid shaft that was meant to be stronger cannot give the way the old split one did. Friction fits between printed parts are done.
- v14: the pegs are double-ended rivets. The bore opened to a clearance fit, nothing rubs, and each end clicks: a bottom barb into a counterbore hidden in the plate's underside, flush, and the top barb through the Pi's hole as before. Two crossed splits, one per barb, each with a long PLA-safe flex. Push to click at both ends, pull the seat bar to free a peg.
- Dropped the stale 3mf, re-export after v14 proves out.
- Sliced v14 with PLA Tough, Jade White: tougher, more ductile, kinder to the flexing barbs than Basic PLA. Saved the project file: [print/pi5-saddle/pi5-saddle-and-pegs.3mf](../print/pi5-saddle/pi5-saddle-and-pegs.3mf). Print started, 16g, 44 minutes.
- First v14 print failed: the pegs stand on two slivers of foot, they came off the bed and strung. Tree supports fixed it, the slicer builds a small disk under each foot. Reprinted, perfect. The working project file is saved, supports on for the pegs.
- The v14 rivets pass: pegs click into the saddle easily and pull back out just as cleanly. Both ends click, nothing fights, nothing breaks. The peg saga is over.

Next: Pi onto the new pegs on the wall, then back to MQTT.

## 2026-08-21: First saddle print failed, redesigned to v5

- Printed the v1 saddle. 0.2mm PLA, no supports, 43 minutes. Heavy stringing, and the bridged underside printed badly.
- Fit test on the wall. The Z11 side is right, the skirt seats well on the cube.
- The Cudy side is wrong. The antennas stand near the Cudy's far end, not along the arm's sides, so the flares are useless and the arm reaching for the far edge ends at the antennas with the foot never touching the surface 10mm below.
- The Pi mount is wrong. The pocket side hits the power button, the latch side hits the ethernet and USB ports, the latch never clicked.
- A top photo decoded the Cudy: the antennas hinge at the sides of the body near its far end and splay outward at body level, one toward the wall, one toward the room. They never rise through the arm. The hinge fronts sit about 30mm from the cube face. The cube is 51mm each way, not 50.
- Redesigned as v4. The antenna flares, chamfers, and through slots are gone. Open notches on the arm's side edges span the hinge zone, room for the paddles raised or splayed, no hinge load. The foot lands on the clear flat with its far face against the hinge fronts, which stops the saddle sliding off the open side; the left skirt wall stops the other direction.
- The edge grips are gone. The Pi mounts by its four mounting holes, the only spots on a Pi 5 guaranteed free of parts. Nothing touches the board edges.
- Cube cavity kept at the printed 51.0 that fit well.
- The photo is scaled off the 51mm cube, good for layout, not for lengths: the Cudy top sits lower and reads about 15 percent short. The tape numbers stand where they conflict: 54 protrusion, 16 hump, 10 drop, 58 width. hinge_x is the one photo length the fit depends on, set to 30, ruler check pending.
- Split the pegs into separate press-in parts as v5. The saddle's top is flat now, so it prints upside down on the bed, no supports and no bridges, which removes what failed in print one. The pegs print standing, four plus two spares. Press them into the board first, then drop board and pegs into sockets in the plate; the board's weight traps the flanges.
- The stringing was moisture, dry the spool.

Next: check hinge_x with a ruler, print the saddle and the pegs, test fit.

## 2026-08-21: Power corner up, Pi 5 saddle designed

- Bought the LDNIO Z11 socket extender, 4 AC outlets, and plugged it into the wall socket by the main router.
- Plugged the Cudy AC1200 mesh WiFi extender into the Z11's right face. It bridges the Pi 5 to the network over ethernet.
- The Pi 5, its power supply, and the ethernet cable still need a home. Decided against a wall box: no screws in the wall, no closed box around a hot Pi. Instead a printed saddle that rests on the Z11 and the Cudy.
- The web has no body dimensions for the Z11 or the indoor AC1200. Measured by hand: Z11 cube 50x50x50, sticking 70mm from the wall. Cudy protrudes 54mm from the Z11 face, a 16mm plug hump then a 58x38 flat top, 10mm below the Z11 top. Antennas flank the flat top, 58mm gap between them.
- Designed the saddle: [print/pi5-saddle.scad](../print/pi5-saddle/pi5-saddle.scad). A platform caps the Z11 with a skirt gripping three sides, a 54mm arm passes between the antennas, a foot steps down 10mm onto the Cudy flat. Vent windows under the board, zip tie slots as fallback anchors.
- No screws anywhere. The Pi slides onto the tray: edge ribs lift the board 3mm, side guides set it straight, two pockets catch the left edge, a latch clicks behind the right edge. Press the latch, slide right, the Pi is out.
- Flared notches on the arm sides nest around the antenna bases as lateral guides. No vertical load on the antennas, they are hinged plastic and would droop.
- One part, prints upright, no supports, fits the A1 mini bed. PLA Basic Black.

Next: print, test fit, adjust one variable and reprint if needed.

## 2026-08-21: Doorbell and lock on MQTT

- Wrote the `kronk-gate` daemon in Go: the GPIO27 button publishes `kronk/doorbell`, `UNLOCK` on `kronk/lock/set` pulses the GPIO17 relay for 3s and publishes `kronk/lock/state`. Source and topics in [gate/README.md](../gate/README.md).
- Added a release workflow that builds `kronk-gate-arm64` on `gate-v*` tags, and a CI workflow that builds on pull requests.
- Review hardened the lock logic: retained commands are ignored and cleared so a reconnect cannot replay an unlock, the relay actuates before any state publish, state follows the actual pin writes, publishes are bounded at 5s, and shutdown waits out an in-flight pulse then forces the relay low.
- Tagged `gate-v0.1.0`. First release, `kronk-gate-arm64` attached.

Next: Mosquitto on the Pi 5, MQTT lock and doorbell entities in Home Assistant, HomeKit.

## 2026-08-09: Relay wired, Kronk gets hands

- Wired the relay's control side to `kronk-gate` with three F-F jumpers: VCC to pin 2 (5V), GND to pin 6, IN to pin 11 (GPIO17). Red for power, black for ground, a bright color for signal.
- The relay's three screw terminals, COM, NO, NC, are the switched side. The gate opener lands on COM and NO later. Normally open means the gate stays locked if power drops.
- Installed `python3-gpiozero` and pulsed GPIO17. The relay clicked on and off, only during the script and not at boot, so the board is not active low. Kronk has hands.
- Started on the doorbell button, GPIO27. It has four terminals, two for the switch and two for the 12V LED ring. Found the pairs.
- Leaving the LED ring unconnected, it wants 12V. The button gets a 3D printed housing later.
- Wired the switch contacts to pin 13 (GPIO27) and pin 14 (GND) with M-F jumpers, the male pin twisted around the terminal. Good enough for the desk, soldering comes before anything mounts outside. Pressed the button, DING printed. The doorbell nerve is alive.
- Turns out the building already has a wired doorbell with a button per floor. Option for later: tap that line instead of new wiring, or a separate board for the floors. Those bells often run 8 to 12V AC, so it needs a voltage measurement and an optocoupler before touching GPIO.

Next: wire relay and button into MQTT and Home Assistant.

## 2026-08-09: Headers soldered, everything moved to a hotspot

- Installed Scrypted on the Pi 5. Needed to add its repository first.
- Settled the division of labor: Scrypted is the eyes, the camera lane where speed matters. Home Assistant is the hands, GPIO, automations, and the future lock. The doorbell and lock path will be gate GPIO, MQTT, HA entity, HomeKit.
- Bought the UGreen OTG adapter for the mic.
- Solder hunt: a candidate wire at home would not melt on the iron, so it was not solder. Bread ties are thin steel and do not bond either. A friend had activated flux core solder wire, which is electronics-grade, ideally under 1mm diameter.
- Took the Zero, the iron, and the electronics to the friend's house. Soldered the headers onto the Pi Zero 2 W. First soldering job done.
- Set up the Apple TV there too, connected to my hotspot.
- Reset the Pi 5 for the new network. Ethernet cannot reach a hotspot, so the WiFi details went on a FAT32 USB stick for Home Assistant to import. Reset the Pi Zero 2 W with the hotspot details as well. The resets turned out to be unnecessary, the USB network import also works on an existing install.
- Set up Scrypted on the Pi 5 again.

- Found `http://homeassistant.local:4357`, the observer page that shows Home Assistant's health while the main page is still loading.
- The WiFi config USB has to stay plugged into the Pi 5. Remove it and the network drops.
- Plugged the mic into `kronk-gate` through the OTG adapter. `arecord -l` lists it as card 0, USB PnP Sound Device. Swapped the test tone in [gate/go2rtc.yaml](../gate/go2rtc.yaml) for the mic at `plughw:0,0`.

- Reworked the camera path: removed the Gate camera from Home Assistant. The camera goes through Scrypted only.
- Installed the Scrypted add-on with the repository from its [install guide](https://github.com/koush/scrypted/wiki/Installation:-Home-Assistant-OS), then the `@scrypted/homekit` and `@scrypted/rtsp` plugins.
- Set up the camera in Scrypted from the go2rtc RTSP stream. Skipped the Scrypted Home Bridge and enabled the HomeKit extension on the camera itself, so it pairs in Apple Home as its own accessory. Steps in [home setup](home-setup.md).
- The mic worked but the volume was very low, face against the mic to be heard.
- Raised the ALSA capture gain in `alsamixer` on the USB card, to about 85 since 100 clips, and persisted it with `sudo alsactl store`. `vc4-hdmi` in the device list is the Pi's HDMI output, not the mic.
- Upgraded the video line to 1920x1080 at 25fps, 2Mb/s, with `--intra 100` for a 4 second keyframe interval, matching Scrypted's recommendations. The earlier 1280-wide line came out as 1280x480 with no explicit height.
- Long audio codec fight. Scrypted detected the AAC track as unknown, and HomeKit takes only Opus or PCM-mulaw. Tried an `#audio=opus` transform stream, PCM-mulaw, and Opus in ogg over the exec pipe. Audio piped from `exec:ffmpeg` never registered, the go2rtc info page showed the producer as a bare url with no tracks.
- The fix: go2rtc's native ffmpeg device source, `ffmpeg:device?audio=plughw:0,0#audio=opus#raw=-af volume=24dB`. Native Opus with a 24dB boost. Scrypted now detects h264/opus. Final config in [gate/go2rtc.yaml](../gate/go2rtc.yaml).
- Debugging tools that cracked it: the `info` link on `http://kronk-gate.local:1984` lists every producer, track, and codec, and `journalctl -u go2rtc` shows the spawned ffmpeg's errors.
- Set the Scrypted RTSP parser to Scrypted (TCP). UDP over WiFi drops frames.
- Video in Apple Home is much faster now with the native Opus stream.
- Confirmed: audio plays in Apple Home, the volume is great, and the camera is real time on the home network. Kronk's ears are online.
- Viewing from outside the home network, through the Apple TV hub, is slow, and poor over cellular. Candidate fix for later: a low bandwidth substream in Scrypted, 640x360 around 400Kbps, assigned as the remote stream.
- The Home app showed no Recording section even with iCloud+. HomeKit Secure Video requires the camera to expose a motion sensor, without one Apple hides recording entirely.
- Installed `@scrypted/objectdetector` and `@scrypted/opencv`, and enabled the OpenCV Motion Detection extension on the camera with default settings. Left FFmpeg Audio Detection off, the street would trigger it constantly.
- Reset Pairing, re-added the camera, and picked Stream and Record during setup. Recording options and Face Recognition appeared. HomeKit Secure Video is live. Steps in [home setup](home-setup.md).

The camera pillar is complete: camera, go2rtc, Scrypted, HomeKit, with HKSV clips, face recognition, and live audio.

Next: wire the relay and the doorbell button.

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
