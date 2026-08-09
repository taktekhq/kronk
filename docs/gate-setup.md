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
