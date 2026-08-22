# Prints

3D printed parts. Printer: Bambu Lab A1 Mini. Filament: PLA Basic Black.

## Pi 5 saddle

[pi5-saddle.scad](pi5-saddle.scad), rendered to [pi5-saddle.stl](pi5-saddle.stl) and [pi5-pegs.stl](pi5-pegs.stl).

Tray for the Raspberry Pi 5. Plugs into the top socket of the LDNIO Z11 socket extender and cantilevers over the Cudy AC1200. No wall screws, no board screws, tool free. Two parts: the saddle, and press-in pegs.

v8. The plug carries everything: two solid prongs on a round base, shaped like a plug face, enter the top socket. The base nests in the round well, the contacts grip the prongs, hold-down and lateral lock in one push. No foot on the Cudy, the arm cantilevers over it. The skirt walls are 4mm alignment guides on the left and room sides only. The top is flat, so the saddle prints upside down with no supports and no bridges.

Safety: prongs and base are solid plastic, the same idea as a child safety blanking plug. Keep them that way. No metal, no foil, no hollow prongs, and if a prong ever snaps off inside the socket, pull it out with pliers before replugging anything.

Check before printing, against the top socket:

- `prong_gap`: hole spacing center to center, set to 19.
- `well_depth`: cube top surface down to the socket face, set to 9.
- `base_d`: the round base is 30, it must be smaller than the well.
- `prong_along_y`: true means the two holes line up wall-to-room. Set false if they line up along the wall.

Print:

- Saddle: exactly as the STL opens, flat face on the bed. No supports, nothing to bridge.
- Pegs: standing as the STL opens, six of them, four plus two spares. Add a brim.
- 0.2mm layers, PLA. Dry the spool: 45 to 50C oven for 4 to 6 hours, keep it bagged after.
- Regenerate after edits:
  `openscad -o pi5-saddle.stl pi5-saddle.scad`
  `openscad -D 'part="pegs"' -o pi5-pegs.stl pi5-saddle.scad`

Assembly:

- Press the four pegs into the Pi's mounting holes from below, pin side up into the board, flange against the underside.
- Line the prongs over the top socket's holes and push the saddle straight down until the plate sits on the cube. The arm floats over the Cudy.
- Drop the board with its pegs into the four sockets. The flanges keep 3mm of air under the board for the microSD card, and the board's weight traps the pegs.
- Pi off: lift straight up. Saddle off: pull straight up, it unplugs.
- Optional anchor, only if the fit is loose: a zip tie around the arm and the Cudy through the arm edge notches.

Fit:

- Cube grip: tune `clr`. Pin tight or loose in the board: tune `pin_d`. Peg in the saddle: tune `socket_d`. Prong grip in the socket: tune `prong_d`. Base in the well: tune `base_d`. One variable per reprint.
