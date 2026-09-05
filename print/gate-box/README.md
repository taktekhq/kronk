# Gate box

Filament: PLA.

[gate-box.scad](gate-box.scad), rendered to [gate-box-tub.stl](gate-box-tub.stl) and [gate-box-lid.stl](gate-box-lid.stl).

Wall box for the gate unit: Pi Zero 2 W, camera, USB mic, doorbell button, relay, power cable. One name for now. Two parts: the tub, and the faceplate.

v1, not printed yet. Outside 101 x 133 x 41mm.

The tub screws to the wall through four holes in its back. It carries the Pi on the [pi5-saddle](../pi5-saddle/README.md) rivet pegs, same sockets, and the relay in a corner cradle above it. The bottom wall has a closed slot for the power cable, a hole for the gate opener wires, a grille under the mic, and two vent slots.

The faceplate carries the camera, the name rows, and the buttons. It caps the tub with an outer skirt so rain runs past the seam, and screws on with four M3 countersunk screws into the corner bosses. Four pillars inside reach down to the relay's edges and box it in, no clip, no screw. The camera sits on four posts with M2 screws, lens one millimeter behind the front face.

Inside, top to bottom: relay on the back wall with the camera in front of it, the Pi with its header facing the faceplate, then the OTG adapter, the mic, and the power plug hanging off the Pi's bottom edge to the exits. The button and the name sit beside the mic chain over clear back wall, room for the jumper housings on the lugs. Both jumper chains, F-F off the Pi then F-M to the relay and button, live in the depth above the header and unplug at the joint with the faceplate off.

Names: one row per entry in `names`, top to bottom, name engraved on the left, button on the right. Add a name, the box grows a row. Every extra button needs its own GPIO pin and its own two jumpers. Set the real name before printing, the default is a placeholder.

Measure before printing, all marked MEASURE in the source: the relay module's PCB, height, and bare edge strip; the OTG adapter and mic as one plugged-in chain; the camera's lens height and lens center; the button behind the faceplate with jumpers on.

Print:

- Tub: as the STL opens, open side up. No supports.
- Faceplate: as the STL opens, face on the bed. No supports.
- 0.2mm layers, PLA. Dry the spool.
- Regenerate after edits:
  `openscad -o gate-box-tub.stl gate-box.scad`
  `openscad -D 'part="lid"' -o gate-box-lid.stl gate-box.scad`
- Preview with `part="assembly"`: dummy volumes for every part, and the derived sizes echo to the console.

Assembly:

- Screw the tub to the wall, four screws through the back.
- Press four pegs into the Pi sockets, board on, header toward you.
- Relay into the cradle, PCB on the corner pads.
- Power cable in through the bottom slot, plug into PWR. OTG adapter with the mic into USB, mic tip down over the grille.
- Camera on the faceplate posts, ribbon down and to the Pi's right edge.
- Button through its hole, nut inside.
- Jumpers: F-F on the Pi, F-M on the relay and the button, join the ends.
- Faceplate on, four M3 screws.

Fit:

- Skirt over the tub: `clr`. Relay play in the cradle: `relay_clr`. Pillar gap over the relay: the 0.5 in `pillar_h`. Lens depth in the window: `cam_recess`. Name too long for its row: `name_size`. One variable per reprint.
