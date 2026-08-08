# Indoor Unit Setup

Steps to set up the [Pi 5](parts.md#indoor-unit). Work in progress.

## Home Assistant

1. Install the [Active Cooler](parts/active-cooler.md).
2. Flash the SD card with Home Assistant.
3. Boot with ethernet and a solid power outlet, then finish onboarding. You can watch status and logs during setup.
4. Update the software and reboot.

## Apple Home

1. Add the HomeKit Bridge integration in Home Assistant.
2. Add the bridge to Apple Home.
3. An Apple TV signed into the same account becomes the Home hub automatically, which gives access over the internet.

## Gate camera

The go2rtc brand did not show in the integration list, so the camera comes in as Generic Camera.

1. Settings, Devices and Services, Add Integration, Generic Camera.
2. Stream URL: `rtsp://kronk-gate.local:8554/gate`. go2rtc serves RTSP on 8554 automatically.
3. Leave still image URL, username, and password blank. go2rtc has no auth, LAN only.
4. Name the entity Gate and put it on the dashboard.

The RTSP card lags a few seconds. A WebRTC integration is the later latency fix.

## Gate camera in Apple Home

1. Settings, Devices and Services, HomeKit Bridge, Configure.
2. In camera configuration, check Gate under cameras that support native H.264 streams. rpicam-vid outputs H.264, so the Pi 5 relays the stream instead of transcoding. Transcoding is too heavy for it.
3. Check Gate under cameras that support audio.
