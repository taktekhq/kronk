# Prints

3D printed parts. Printer: Bambu Lab A1 Mini. Filament: PLA Basic Black.

## Pi 5 saddle

[pi5-saddle.scad](pi5-saddle.scad), rendered to [pi5-saddle.stl](pi5-saddle.stl).

Tray for the Raspberry Pi 5. Rests on the LDNIO Z11 socket extender and the Cudy AC1200 WiFi extender. No wall screws, no board screws, tool free.

Print:

- Orientation: upright, as modeled, skirt and foot on the bed. No supports.
- The plate underside prints as bridges. Rough is fine, it faces the devices. Enable thick bridges if the slicer offers it.
- Regenerate the STL after edits: `openscad -o pi5-saddle.stl pi5-saddle.scad`

Assembly:

- Cap the Z11 with the platform. The skirt grips three sides, the right side stays open for the Cudy.
- The arm passes between the antennas, the flared side notches nest around their bases, the foot lands on the Cudy flat top. The antennas carry no weight.
- Pi in: USB-C edge facing the room, ports edge right. Set the board on the ribs between the guide walls, slide left under the two pocket lips until it clicks past the latch.
- Pi out: press the latch tab down, slide the board right, lift.
- Optional anchors, only if the fit is loose: one zip tie around the Z11 through the three skirt slots, one around the arm and the Cudy through the arm edge notches.

Fit:

- Test fit before mounting. Rocking: tune `cudy_drop`. Tight or loose on the cube: tune `clr`. Latch too stiff or weak: tune `nub_h`. Antenna notches off: tune `ant_x`. One variable per reprint.
