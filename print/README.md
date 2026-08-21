# Prints

3D printed parts. Printer: Bambu Lab A1 Mini. Filament: PLA Basic Black.

## Pi 5 saddle

[pi5-saddle.scad](pi5-saddle.scad), rendered to [pi5-saddle.stl](pi5-saddle.stl).

Tray for the Raspberry Pi 5. Rests on the LDNIO Z11 socket extender and the Cudy AC1200 WiFi extender. No wall screws, no board screws, tool free.

v2. The v1 fit test passed on the Z11 and failed on everything else: the arm ran into the antennas at the Cudy's far end, and the edge grips hit the power button and the ports. v2 lands the foot just past the plug hump, clear of the antennas, and mounts the Pi on four pegs in its mounting holes. Nothing touches the board edges.

Print:

- Orientation: upright, as modeled, skirt and foot on the bed. Do not rotate.
- Supports ON: tree, build plate only. They fill the skirt cavity and under the arm and pop out. The top stays clean.
- 0.2mm layers, PLA.
- Stringing is filament, not the model: dry the PLA, tune retraction.
- Regenerate the STL after edits: `openscad -o pi5-saddle.stl pi5-saddle.scad`

Assembly:

- Cap the Z11 with the platform. The skirt grips three sides, the right side stays open for the Cudy.
- The short arm crosses the plug hump, the foot lands on the Cudy flat just past it, before the antennas.
- Pi on: line the four mounting holes over the pegs, press down. Two pegs are slightly fat and grip by friction. The pads keep 3mm of air under the board for the microSD card.
- Pi off: lift straight up.
- Optional anchors, only if the fit is loose: one zip tie around the Z11 through the three skirt slots, one around the arm and the Cudy through the arm edge notches.

Fit:

- Rocking between cube and foot: tune `cudy_drop`. Tight or loose on the cube: tune `clr`. Pegs tight or loose: tune `peg_d`, `peg_extra`. Foot not on clear flat: tune `arm_len`. One variable per reprint.
