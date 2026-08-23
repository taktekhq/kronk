# Parts

What you need to build kronk, and what I got. Prices are in the [bill](bill.csv).

## Gate unit

- Small computer: Raspberry Pi Zero 2 W, no header. I got 2.
- Low light camera: [Raspberry Pi Camera Module 3 NoIR](parts/camera.md), original, not Wide
- Camera cable for the Pi Zero: Raspberry Pi Zero camera cable
- Doorbell button: [metal push button, momentary, 12mm, LED ring](parts/push-button.md)
- Microphone: [USB 2.0 mini microphone](parts/microphone.md)
- Relay for the gate opener: [1 channel 5V relay](parts/relay.md)
- Power: [12V to 5V 3A buck converter](parts/buck-converter.md)
- Microphone adapter: micro USB male to USB-A female (OTG). A plain cable does not work. Getting a UGreen Micro USB Male to USB 2.0 Female Adapter Converter.

From home, not in the [bill](bill.csv):

- Power cable: micro USB to USB-A. I used one I had.
- Power brick with a USB-A port: any charger works. I used an old Samsung one.

## Indoor unit

- Main computer: Raspberry Pi 5, 4GB RAM
- Power supply: [official Raspberry Pi 27W USB-C, EU plug](parts/power-supply.md)
- Cooling: [official Raspberry Pi 5 Active Cooler](parts/active-cooler.md)
- Amplifier: [TDA7266 dual channel](parts/amplifier.md)
- Speaker: [stereo speaker, 50mm, 8 ohm, 3W](parts/speaker.md)
- Home hub for internet access: an Apple TV or HomePod. I used an Apple TV I had.

## Indoor mounting

The indoor unit sits on the wall socket by the main router. No wall screws.

- Socket extender, holds everything: LDNIO Z11, 4 AC outlets
- Pi 5 support: [3D printed saddle](../print/README.md) resting on the socket extender and the WiFi extender

From home, not in the [bill](bill.csv):

- WiFi extender for ethernet: Cudy AC1200 mesh (RE1200). I used the one we had.
- 3D printer: Bambu Lab A1 Mini
- Filament: PLA, Basic Black then PLA Tough Jade White
- Zip ties for the saddle, only if the fit is loose

## Storage

- SD card for the Pi 5: Adata microSDXC 64GB, UHS-I Class 10 V10
- SD cards for the Pi Zeros: Adata micro SD 32GB, Class 10. I got 2.
- Card reader: [UGreen 2 in 1 USB-C and USB-A SD/TF reader](parts/card-reader.md)

## Tools and wiring

- Soldering iron: 60W, adjustable temperature
- Solder: activated flux core solder wire, under 1mm diameter. Borrowed from a friend.
- GPIO headers: 40 pin male, single row, 2.54mm pitch. I got 2, one per Pi Zero.
- Jumper wires: DuPont 20cm, 40 piece packs. I got M-M, M-F, and F-F.

Note: the Pi Zero 2 W with pre-soldered header was out of stock, hence the headerless boards, separate headers, and soldering iron.
