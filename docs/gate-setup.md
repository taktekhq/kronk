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
