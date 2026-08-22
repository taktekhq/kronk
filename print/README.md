# Prints

3D printed parts. Printer: Bambu Lab A1 Mini. Filament: PLA Basic Black.

## Pi 5 saddle

[pi5-saddle.scad](pi5-saddle.scad), rendered to [pi5-saddle.stl](pi5-saddle.stl) and [pi5-pegs.stl](pi5-pegs.stl).

Tray for the Raspberry Pi 5. Plugs into the top socket of the LDNIO Z11 socket extender and cantilevers over the Cudy AC1200. No wall screws, no board screws, tool free. Two parts: the saddle, and press-in pegs.

v10. The plug carries everything: two solid prongs on a round base, shaped like a plug face, enter the top socket. The prongs follow the European convention, 4.8mm thick with 19mm engagement past the socket face, and lean 0.5mm toward each other like a Europlug's converging pins, so the socket bends them straight and the springback grips. The base fills the measured 38mm well, 0.2 shy of its 4mm floor, so the plate seats on the cube and the base bears just after. No foot on the Cudy, the arm cantilevers over it. The skirt walls are 4mm alignment guides on the left and room sides only. The top is flat, so the saddle prints upside down with no supports and no bridges.

The pegs are snap pins like the Pi active cooler's: a split runs the whole peg, the barbed tip squeezes through the board's mounting hole and clicks open above it, and the split shaft squeezes snug into the saddle socket. The board clicks on and resists lifting; a firm straight pull, or pinching the tips, releases it.

Safety: prongs and base are solid plastic, the same idea as a child safety blanking plug. Keep them that way. No metal, no foil, no hollow prongs, and if a prong ever snaps off inside the socket, pull it out with pliers before replugging anything.

Top socket numbers, all confirmed on the wall: holes 19 apart lined up wall-to-room, well 38 wide and 4 deep to the socket face.

Print:

- Saddle: exactly as the STL opens, flat face on the bed. No supports, nothing to bridge.
- Pegs: standing as the STL opens, six of them, four plus two spares. Add a brim.
- 0.2mm layers, PLA. Dry the spool: 45 to 50C oven for 4 to 6 hours, keep it bagged after.
- Regenerate after edits:
  `openscad -o pi5-saddle.stl pi5-saddle.scad`
  `openscad -D 'part="pegs"' -o pi5-pegs.stl pi5-saddle.scad`

Assembly:

- Press the four pegs into the saddle's sockets, they squeeze in snug.
- Line the prongs over the top socket's holes and push the saddle straight down until the plate sits on the cube. The arm floats over the Cudy.
- Line the board's mounting holes over the peg tips and press down until the barbs click through. The seat bars keep 3mm of air under the board for the microSD card.
- Pi off: a firm straight pull, or pinch the peg tips and lift corner by corner. Saddle off: pull straight up, it unplugs.
- Optional anchor, only if the fit is loose: a zip tie around the arm and the Cudy through the arm edge notches.

Fit:

- Cube grip: tune `clr`. Board click too weak or too fierce: tune `barb_d`. Peg tight or loose in the saddle: tune `shaft_d`. Saddle pulls out too easily: raise `prong_lean`. Insertion fights: lower `prong_lean` or `prong_d`. Base in the well: tune `base_d`. One variable per reprint.
