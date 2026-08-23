# Indoor Unit Setup

Steps to set up the [Pi 5](parts.md#indoor-unit). Work in progress.

## Home Assistant

1. Install the [Active Cooler](parts/active-cooler.md).
2. Flash the SD card with Home Assistant.
3. Boot with ethernet and a solid power outlet, then finish onboarding. You can watch status and logs during setup.
   On WiFi instead: put the network details on a FAT32 USB stick named CONFIG. The stick has to stay plugged in, WiFi drops without it.
   `http://homeassistant.local:4357` shows Home Assistant's health while the main page is still loading.
4. Update the software and reboot.

## Apple Home

An Apple TV signed into the same account becomes the Home hub automatically, which gives access over the internet.

Two paths into Apple Home, both further down: the camera and doorbell pair from Scrypted, the lock through the [YAML HomeKit Bridge](#lock-in-apple-home). Don't add a HomeKit Bridge from the integrations UI, a second bridge doubles the lock.

Keep Apple devices out of Home Assistant. The Apple TV integration loops back through the HomeKit Bridge and fills Apple Home with ghost duplicates.

## Gate camera through Scrypted

The camera does not go through Home Assistant. Scrypted serves it to Apple Home directly. It cuts the latency of Home Assistant's HomeKit Bridge repackaging the stream.

1. Install the Scrypted add-on. Add the repository from the [install guide](https://github.com/koush/scrypted/wiki/Installation:-Home-Assistant-OS), then install.
2. Enable everything in the add-on controls: start on boot, watchdog, auto update, show in sidebar. Then start Scrypted.
2. In Scrypted, install the `@scrypted/homekit` and `@scrypted/rtsp` plugins.
3. Add the camera with the go2rtc RTSP URL: `rtsp://kronk-gate.local:8554/gate`.
4. Skip the Scrypted Home Bridge. Enable the HomeKit extension on the camera itself, so it pairs in Apple Home as its own accessory. Scan its QR code in the Home app.

Stream settings:

- RTSP Parser: Scrypted (TCP). The stream crosses WiFi, and UDP drops show as gray smears and corrupt frames.
- Prebuffered Streams: on. Scrypted keeps a rolling buffer so HomeKit opens instantly, and it feeds HomeKit Secure Video motion events.
- Keep the Rebroadcast, Snapshot, and WebRTC plugins on. Rebroadcast drives the prebuffer, Snapshot feeds the Home app tile.
- Detected stream should read 1920x1080 around 2000Kb/s, h264/opus, 4 second keyframe interval. That matches everything Scrypted recommends.

If re-adding the camera says it is part of a different home, use Reset Pairing in the camera's HomeKit section to get a fresh QR code.

## MQTT broker

The [`kronk-gate` daemon](../gate/README.md) publishes the doorbell and lock over MQTT.

1. Install the Mosquitto broker add-on (Settings, Apps) and start it.
2. Create a Home Assistant user `kronk-gate` for the daemon. Mosquitto accepts Home Assistant credentials.
3. Add the MQTT integration. It finds the add-on broker.
4. Put the credentials in the daemon's env file on `kronk-gate`. Broker URL: `tcp://homeassistant.local:1883`. The daemon resolves `.local` over mDNS itself, details in the [daemon README](../gate/README.md#deploy).

Lock and doorbell entities in `configuration.yaml`:

```yaml
mqtt:
  lock:
    - name: Gate
      command_topic: kronk/lock/set
      state_topic: kronk/lock/state
      payload_unlock: UNLOCK
      state_locked: LOCKED
      state_unlocked: UNLOCKED
      availability_topic: kronk/status
  event:
    - name: Gate doorbell
      state_topic: kronk/doorbell
      event_types: [ding]
      device_class: doorbell
      value_template: '{"event_type": "{{ value }}"}'
      availability_topic: kronk/status
```

The Lock button does nothing by design. The relay is momentary, the gate locks itself after the pulse.

The event entity feeds automations and the logbook. Rings reach Apple Home through Scrypted instead.

## Lock in Apple Home

The HomeKit Bridge cannot expose event entities, and a UI bridge next to a YAML bridge doubles the lock. One YAML bridge, in `configuration.yaml`:

```yaml
homekit:
  - name: Kronk Bridge
    filter:
      include_entities:
        - lock.gate
```

Restart Home Assistant, then scan the pairing QR code from the sidebar notification in the Home app.

## Doorbell through Scrypted

The gate button rings Apple Home as a video doorbell on the camera, snapshot in the notification.

1. Create a Home Assistant user `scrypted` for the broker, local only, not admin.
2. In Scrypted, install the `@scrypted/mqtt` and `@scrypted/dummy-switch` plugins.
3. MQTT plugin, Add New: name `Gate doorbell button`, template `button.ts`, subscription URL `mqtt://127.0.0.1:1883` with no path, the `scrypted` credentials. Credentials go on the device, the plugin's general settings are ignored. Restart the MQTT plugin after creating it, settings only load when the script runs.
4. The script pulses, the daemon sends `ding` with no release:

   ```ts
   mqtt.subscribe({
       'kronk/doorbell': value => {
           if (value.text !== 'ding') return;
           device.binaryState = true;
           setTimeout(() => device.binaryState = false, 3000);
       },
   });
   mqtt.handleTypes(ScryptedInterface.BinarySensor);
   ```

   Press the button: the device Console logs the message.
5. On the camera, Extensions: enable Custom Doorbell Button, pick the button, then toggle the extension off and on. The selection only registers when the extension starts. If the device type still says Camera, set it to Doorbell by hand.
6. Camera, HomeKit: Reset Pairing. Remove the camera in the Home app, add it back with the new QR code, it pairs as a doorbell. Re-enable Stream and Allow Recording, HKSV settings reset with the pairing.

## Talk-back through Scrypted

Untested. The gate speaker comes first, this is the path to try after it plays.

HomeKit's microphone button reaches the camera through Scrypted's Intercom capability. A plain RTSP camera has none, the ONVIF plugin provides it.

1. Point the camera at `rtsp://kronk-gate.local:8554/gate?backchannel=1`. go2rtc advertises the incoming audio track only when the URL asks.
2. Install `@scrypted/onvif` and add the gate as an ONVIF camera. Leave Two Way Audio checked.
3. Hold the microphone button on the camera tile in the Home app. The gate speaker plays.

Two frictions:

- The write-ups that got this working set RTSP Parser to Scrypted (UDP). The camera runs TCP because UDP over WiFi smears the video.
- go2rtc takes Opus, PCM, PCMA, PCMU, and AAC on the backchannel. The `info` link on `http://kronk-gate.local:1984` shows whether the track arrived.

Fallback if ONVIF does not take: a Home Assistant shell command posting to the go2rtc API, which plays a fixed clip at the gate. No live talk.

## Recording (HomeKit Secure Video)

HKSV needs iCloud+, an online home hub, and the camera exposing a motion sensor. Without motion, the Home app hides the Recording section entirely.

1. In Scrypted, install `@scrypted/objectdetector` and `@scrypted/opencv`. The detector is the framework, OpenCV is a light engine, enough to gate HKSV for one camera.
2. On the camera, enable the OpenCV Motion Detection extension. Defaults are fine. Leave FFmpeg Audio Detection off, a street-facing mic would trigger it constantly.
3. Keep Prebuffer on. HKSV uses it for pre-motion footage.
4. HomeKit extension, Reset Pairing. In the Home app, remove the stale camera, add the accessory with the new QR code, and pick Stream and Allow Recording during setup.

Recording options and Face Recognition appear in the camera's settings. Activity zones are drawn in the Home app, not Scrypted.
