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

1. Add the HomeKit Bridge integration in Home Assistant.
2. Add the bridge to Apple Home.
3. An Apple TV signed into the same account becomes the Home hub automatically, which gives access over the internet.

Keep Apple devices out of Home Assistant. The Apple TV integration loops back through the HomeKit Bridge and fills Apple Home with ghost duplicates.

## Gate camera through Scrypted

The camera does not go through Home Assistant. Scrypted serves it to Apple Home directly. It cuts the latency of Home Assistant's HomeKit Bridge repackaging the stream.

1. Install the Scrypted add-on. Add the repository from the [install guide](https://github.com/koush/scrypted/wiki/Installation:-Home-Assistant-OS), then install.
2. Enable everything in the add-on controls: start on boot, watchdog, auto update, show in sidebar. Then start Scrypted.
2. In Scrypted, install the `@scrypted/homekit` and `@scrypted/rtsp` plugins.
3. Add the camera with the go2rtc RTSP URL: `rtsp://kronk-gate.local:8554/gate`.
4. Skip the Scrypted Home Bridge. Enable the HomeKit extension on the camera itself, so it pairs in Apple Home as its own accessory. Scan its QR code in the Home app.
