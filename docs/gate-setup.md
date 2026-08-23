# Gate Unit Setup

Steps to set up `kronk-gate`, the [Pi Zero 2 W](parts.md#gate-unit) at the gate. Work in progress.

## Camera

The Pi Zero's camera connector is smaller than standard, so the [NoIR camera](parts/camera.md) needs the Pi Zero camera cable.

1. Open the connector latches on the camera and the Pi.
2. Swap the camera's standard cable for the Pi Zero cable.
3. Close the latches.

Verify:

```
rpicam-hello --list-cameras
```

Should print `imx708`. Test photo:

```
rpicam-still -o first-look.jpg
```

## Video stream

[go2rtc](https://github.com/AlexxIT/go2rtc) streams the camera.

Download it on the Pi:

```
curl -Lo go2rtc https://github.com/AlexxIT/go2rtc/releases/latest/download/go2rtc_linux_arm64 && chmod +x go2rtc
```

Create `go2rtc.yaml` from [gate/go2rtc.yaml](../gate/go2rtc.yaml). The name matters: go2rtc ignores `go2rtc.yml`.

The video line targets what HomeKit and Scrypted recommend: 1920x1080 at 25fps, 2Mb/s, and `--intra 100` for a keyframe every 4 seconds (25fps x 4).

Run `./go2rtc`, open `http://kronk-gate.local:1984`, and click the `gate` stream. Live video in the browser. Use the WebRTC stream, it is much faster than the default. The stream's `info` link lists every track and codec, the first stop when something is off.

## Audio

ffmpeg feeds the audio source in [gate/go2rtc.yaml](../gate/go2rtc.yaml):

```
sudo apt install -y ffmpeg
```

To test without a mic, use a 440Hz sine as the second `exec` source:

```
- exec:ffmpeg -re -f lavfi -i sine=frequency=440:sample_rate=16000 -c:a aac -f adts -
```

The tone is AAC, so it plays over MSE but not WebRTC in the browser. WebRTC only carries Opus audio.

For the real [microphone](parts/microphone.md), plug it in through the OTG adapter, then find its card number:

```
arecord -l
```

Mine showed as card 0, USB PnP Sound Device. `vc4-hdmi` is the Pi's HDMI audio output, not the mic.

Raise the capture gain, it defaults very low. In `alsamixer`: F6 to pick the USB card, F4 for capture view, raise Mic to about 85. 100 clips into static. Persist it:

```
sudo alsactl store
```

The audio source in [gate/go2rtc.yaml](../gate/go2rtc.yaml) uses go2rtc's native ffmpeg device syntax, streaming Opus with a volume boost:

```
- ffmpeg:device?audio=plughw:0,0#audio=opus#raw=-af volume=24dB
```

Opus because that is what HomeKit and Scrypted want. Piping AAC, mulaw, or ogg out of an `exec:ffmpeg` line does not work, go2rtc shows the producer as a bare url with no audio track.

If the mic is silent, isolate mic vs pipeline by recording straight from ALSA:

```
arecord -D plughw:0,0 -f S16_LE -r 16000 test.wav
```

## Speaker

Audio out at the gate, so a visitor hears you from the Home app. The [amp](parts/amplifier.md) and [speaker](parts/speaker.md) mount at the gate. The iPhone is the indoor handset.

The Pi Zero 2 W has no audio jack and no DAC. Three ways out:

- PWM on a GPIO through a passive filter. Uses the amp already bought, needs four passives.
- A USB sound card with an output. The Zero's one USB port holds the mic, so this needs a hub.
- An I2S DAC. Best quality. A board like the MAX98357A is its own amp and retires the TDA7266.

PWM below. Check the mic dongle first, some of them also play:

```
aplay -l
```

A playback device there skips the filter, wire the amp to its jack.

### PWM out

Add to `/boot/firmware/config.txt`, `/boot/config.txt` on older images:

```
dtparam=audio=on
dtoverlay=audremap,pins_12_13
```

Reboot. `aplay -l` lists a `bcm2835 Headphones` card. The mic holds card 0, so address it by name:

```
speaker-test -D plughw:CARD=Headphones,DEV=0 -c 1 -t sine -f 440
```

Silent until the amp and filter are in. Set the level in `alsamixer`, F6 for the card, the `PCM` control, then `sudo alsactl store`.

### Speaker and amp

Build this before the filter. It needs nothing but the amp, the speaker, and 5V, and it proves both parts on their own.

| Amp | To |
|---|---|
| OUT L, both terminals | the [speaker](parts/speaker.md) |
| VCC | 5V from the [buck converter](parts/buck-converter.md), not the Pi's 5V pin |
| GND | buck ground |

- The TDA7266 is bridged. Grounding either output terminal kills the chip.
- The amp on the Pi's 5V pin browns out the Zero.
- 12V drives a 3W speaker past what it survives. 5V gives about 1.5W into 8 ohm.

Bench test with a phone, headphone output into IN L and the amp's ground, any music. The speaker plays. Set the pot below distortion. A dead amp or a dead speaker shows up here, not after the filter is soldered.

### Filter

Only this last hop needs the passives. GPIO12 is the left channel. One channel is enough for voice, GPIO13 stays unused.

| Signal | Zero physical pin |
|---|---|
| PWM left, GPIO12 | 32 |
| ground | 34 |

Values are the ones on the Pi's own audio output:

```
GPIO12 ──270Ω──┬──150Ω──┬──1µF──► amp IN L
               │        │
              33nF     10nF
               │        │
              GND      GND
```

The 1µF blocks DC. Electrolytic, positive side toward the filter. One stage, 270Ω and 33nF, is enough for voice.

The Pi's pin 34 joins the amp's ground. Grounds must be common or the output is noise.

`speaker-test` is audible now.

### Backchannel

`#backchannel=1` makes an `exec` source consume audio instead of producing it. Third source in [gate/go2rtc.yaml](../gate/go2rtc.yaml):

```
- exec:aplay -q -t raw -f S16_LE -c 1 -r 16000 -D plughw:CARD=Headphones,DEV=0#backchannel=1
```

With no `#audio=` go2rtc writes raw signed 16 bit little endian, 16kHz, mono. Hence `-t raw`, there is no WAV header on the pipe.

Restart go2rtc, push a file through it:

```
curl -X POST "http://kronk-gate.local:1984/api/streams?dst=gate&src=ffmpeg:/usr/share/sounds/alsa/Front_Center.wav"
```

The speaker plays it. That covers go2rtc to the cone, with no Apple Home involved.

Consumers must ask for the track, or go2rtc never advertises it:

```
rtsp://kronk-gate.local:8554/gate?backchannel=1
```

The browser's own two-way audio button on port 1984 does not work. Browsers release the microphone only on HTTPS or localhost.

Latency is `aplay`'s buffer. `--buffer-size=2048` is about 130ms.

Mic and speaker in one enclosure will howl. Point them apart, amp pot down before mic gain.

## Relay

The [relay](parts/relay.md) has two sides. The 3 pin control side connects to the Zero. The 3 screw terminals, COM, NO, NC, switch the gate opener circuit and stay empty until that wiring session. The opener goes on COM and NO: normally open keeps the gate locked if power drops.

Three F-F jumpers on the control side:

| Relay | Zero physical pin | Why |
|---|---|---|
| VCC | 2 | 5V for the relay coil |
| GND | 6 | shared ground |
| IN | 11 (GPIO17) | the control signal |

Counting pins: hold the board SD card up with the header on the right. Pin 1 is top left, pin 2 top right, odds run down the left, evens down the right.

Colors: red for VCC, black for GND, a bright color for signal.

Test with nothing on the screw side:

```
sudo apt install -y python3-gpiozero
python3 -c "from gpiozero import OutputDevice; import time; r=OutputDevice(17); r.on(); time.sleep(2); r.off()"
```

The relay clicks on, then off. If it is already energized at boot, the board is active low and the signal needs inverting in software.

## Doorbell button

The [button](parts/push-button.md) has four terminals: two are the switch contacts, two are the 12V LED ring. The LED stays unconnected for now.

Two jumpers on the switch contacts, any order:

| Button | Zero physical pin |
|---|---|
| switch contact | 13 (GPIO27) |
| switch contact | 14 (GND) |

F-F jumpers if the sockets grip the lugs, or M-F with the male pin twisted around the terminal for a desk test. Solder before mounting outside, a loose contact means phantom rings.

Test:

```
python3 -c "from gpiozero import Button; b=Button(27); b.wait_for_press(); print('DING')"
```

Press the button and DING prints.

## Run as a service

Install [gate/go2rtc.service](../gate/go2rtc.service) so go2rtc always runs:

```
sudo cp go2rtc.service /etc/systemd/system/go2rtc.service
sudo systemctl daemon-reload
sudo systemctl enable --now go2rtc
systemctl status go2rtc
```

Status should say active (running). Reboot to confirm the stream survives.

Day to day:

```
sudo systemctl restart go2rtc
systemctl status go2rtc
journalctl -u go2rtc -f
```

## Doorbell and lock daemon

The `kronk-gate` daemon bridges the button and relay to MQTT. Build, deploy, and test steps in [gate/README.md](../gate/README.md).
