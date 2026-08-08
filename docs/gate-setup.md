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

Run `./go2rtc`, open `http://kronk-gate.local:1984`, and click the `gate` stream. Live video in the browser. Use the WebRTC stream, it is much faster than the default.

## Audio

The real microphone is pending an adapter. For now the stream carries a 440Hz test tone.

```
sudo apt install -y ffmpeg
```

The tone comes from the second `exec` source in [gate/go2rtc.yaml](../gate/go2rtc.yaml).

## Run as a service

Install [gate/go2rtc.service](../gate/go2rtc.service) so go2rtc always runs:

```
sudo cp go2rtc.service /etc/systemd/system/go2rtc.service
sudo systemctl daemon-reload
sudo systemctl enable --now go2rtc
systemctl status go2rtc
```

Status should say active (running). Reboot to confirm the stream survives.
