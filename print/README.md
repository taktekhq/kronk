# Prints

3D printed parts. Printer: Bambu Lab A1 Mini. Filament: PLA Basic Black.

## Pi 5 saddle

[pi5-saddle.scad](pi5-saddle.scad), rendered to [pi5-saddle.stl](pi5-saddle.stl) and [pi5-pegs.stl](pi5-pegs.stl).

Tray for the Raspberry Pi 5. Rests on the LDNIO Z11 socket extender and the Cudy AC1200 WiFi extender, and plugs into the Z11's top socket. No wall screws, no board screws, tool free. Two parts: the saddle, and press-in pegs.

v7. Two solid prongs under the plate plug into the cube's top socket, the one the saddle covers anyway, like a child blanking plug. The socket's sprung contacts grip them: hold-down and lateral lock in one move. The antenna notches are gone, the splayed antennas never reach the arm. No skirt on the wall side, the v5 print hit the outlet's raised edge there; left and room side skirts remain as alignment guides. The saddle top is flat, so it prints upside down with no supports and no bridges.

Safety: the prongs are solid plastic, the same idea as a child safety blanking plug. Keep them that way. No metal, no foil, no hollow prongs, and stop if one ever snaps off inside the socket, pull it out with pliers before replugging anything.

Check before printing, three top-socket numbers:

- `prong_gap`: hole spacing center to center, set to 19.
- `well_depth`: cube top surface down to the socket face, set to 9.
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
- Line the prongs over the top socket's holes and push the saddle straight down until the plate sits on the cube. The arm crosses the Cudy, the foot lands on its flat.
- Drop the board with its pegs into the four sockets. The flanges keep 3mm of air under the board for the microSD card, and the board's weight traps the pegs.
- Pi off: lift straight up. Saddle off: pull straight up, it unplugs.
- Optional anchors, only if the fit is loose: zip ties through the skirt slots and the arm edge notches.

Fit:

- Rocking between cube and foot: tune `cudy_drop`. Cube grip: tune `clr`. Pin tight or loose in the board: tune `pin_d`. Peg in the saddle: tune `socket_d`. Prong grip in the socket: tune `prong_d`. Foot placement: tune `foot_x`. One variable per reprint.
