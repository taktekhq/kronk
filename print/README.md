# Prints

3D printed parts. Printer: Bambu Lab A1 Mini. Filament: PLA Basic Black.

## Pi 5 saddle

[pi5-saddle.scad](pi5-saddle.scad), rendered to [pi5-saddle.stl](pi5-saddle.stl) and [pi5-pegs.stl](pi5-pegs.stl).

Tray for the Raspberry Pi 5. Rests on the LDNIO Z11 socket extender and the Cudy AC1200 WiFi extender. No wall screws, no board screws, tool free. Two parts: the saddle, and press-in pegs.

v5. The pegs are separate parts, so the saddle's top is flat and it prints upside down on the bed with no supports and no bridges. The antennas hinge at the sides of the Cudy's body and splay outward; open notches on the arm edges give them room, and the foot butts the hinge fronts as the slide stop. The cube is 51mm; the cavity matches the print that fit.

Check before printing, one ruler number:

- `hinge_x`: cube face to the front of the antenna hinges, set to 30. If yours differs by more than 2mm, update and regenerate.

Print:

- Saddle: exactly as the STL opens, flat face on the bed. No supports, nothing to bridge.
- Pegs: standing as the STL opens, six of them, four plus two spares. Add a brim.
- 0.2mm layers, PLA. Dry the spool: 45 to 50C oven for 4 to 6 hours, keep it bagged after.
- Regenerate after edits:
  `openscad -o pi5-saddle.stl pi5-saddle.scad`
  `openscad -D 'part="pegs"' -o pi5-pegs.stl pi5-saddle.scad`

Assembly:

- Press the four pegs into the Pi's mounting holes from below, pin side up into the board, flange against the underside.
- Cap the Z11 with the platform, skirt on three sides, arm over the Cudy, foot on the flat in front of the antenna hinges. The antennas stay splayed or raised, the side notches give them room.
- Drop the board with its pegs into the four sockets. The flanges keep 3mm of air under the board for the microSD card, and the board's weight traps the pegs.
- Lift straight up to remove, pegs come along with the board.
- Optional anchors, only if the fit is loose: one zip tie around the Z11 through the three skirt slots, one around the arm and the Cudy through the arm edge notches.

Fit:

- Rocking between cube and foot: tune `cudy_drop`. Cube grip: tune `clr`. Pin tight or loose in the board: tune `pin_d`. Peg tight or loose in the saddle: tune `socket_d`. Foot placement: tune `hinge_x`. One variable per reprint.
