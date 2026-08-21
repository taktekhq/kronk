# Prints

3D printed parts. Printer: Bambu Lab A1 Mini. Filament: PLA Basic Black.

## Pi 5 saddle

[pi5-saddle.scad](pi5-saddle.scad), rendered to [pi5-saddle.stl](pi5-saddle.stl).

Tray for the Raspberry Pi 5. Rests on the LDNIO Z11 socket extender and the Cudy AC1200 WiFi extender. No wall screws, no board screws, tool free.

v3. The v1 fit test passed on the Z11 and failed on the rest. A top photo then showed the Cudy's antennas are fold flat paddles at the far end of its top. v3: foot lands mid flat before the antenna hinges, two through slots in the arm let the raised paddles pass and key the saddle against sliding, and the Pi drops onto four pegs in its mounting holes. Nothing touches the board edges, no load on the antenna hinges.

Measure before printing, then update the file and regenerate:

- `paddle_x`: cube face to paddle center
- `paddle_span`: between the two paddle centers
- `paddle_w`, `paddle_t`: one paddle's width and thickness

Print:

- Dry the spool first. The v1 stringing was moisture: 45 to 50C oven for 4 to 6 hours works, keep the spool bagged after.
- Orientation: upright, as modeled, skirt and foot on the bed. Do not rotate, do not autorotate.
- Supports ON: tree, build plate only. They fill the skirt cavity and under the arm and pop out. The top stays clean.
- 0.2mm layers, PLA.
- Regenerate the STL after edits: `openscad -o pi5-saddle.stl pi5-saddle.scad`

Assembly:

- Fold the Cudy's antennas flat. Cap the Z11 with the platform, skirt on three sides, arm over the Cudy, foot on the flat.
- Raise the antennas through the arm slots. They key the saddle in place.
- Pi on: line the four mounting holes over the pegs, press down. Two pegs grip by friction. The pads keep 3mm of air under the board for the microSD card.
- Pi off: lift straight up.
- Optional anchors, only if the fit is loose: one zip tie around the Z11 through the three skirt slots, one around the arm and the Cudy through the arm edge notches.

Fit:

- Rocking between cube and foot: tune `cudy_drop`. Tight or loose on the cube: tune `clr`. Pegs tight or loose: tune `peg_d`, `peg_extra`. Foot placement: tune `foot_x`. One variable per reprint.
