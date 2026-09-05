# Gate box

Filament: PLA.

[gate-box.scad](gate-box.scad), rendered to [gate-box-tub.stl](gate-box-tub.stl), [gate-box-lid.stl](gate-box-lid.stl), and [gate-box-face.stl](gate-box-face.stl).

Wall box for the gate unit: Pi Zero 2 W, camera, USB mic, doorbell button, relay, power cable. An interphone panel with one name. Three parts: the tub, the backplate, and the panel.

v2, not printed yet. Outside 106 x 138 x 44mm.

The tub screws to the wall through four holes in its back. It carries the Pi on the [pi5-saddle](../pi5-saddle/README.md) rivet pegs, same sockets, and the relay in a corner cradle above it. The bottom wall has a closed slot for the power cable, a hole for the gate opener wires, and two vent slots.

The backplate caps the tub with an outer skirt so rain runs past the seam. Inside it carries the camera on four posts with M2 screws, and four pillars that reach down to the relay's edges and box it in, no clip, no screw.

The panel is the face. A raised bezel with the four screws in the corners, a hooded camera eye at the top, blind speaker grooves in the module over the Pi, one label window per name with the button in a collar beside it, seam lines between the modules, and a slotted grille over the mic at the bottom. It prints face up, so everything on it stands proud.

The label is a printed card, 61 x 18mm, behind a clear sheet cut from packaging. Both drop into the pocket on the panel's back, and the backplate closes it. Four M3 screws from the front go through both plates into the tub's corner bosses.

Inside, top to bottom: relay on the back wall with the camera in front of it, the Pi with its header facing the backplate, then the OTG adapter, the mic, and the power plug hanging off the Pi's bottom edge to the exits. The button and the label sit beside the mic chain over clear back wall, room for the jumper housings on the lugs. Both jumper chains, F-F off the Pi then F-M to the relay and button, live in the depth above the header and unplug at the joint with the plates off.

Names: one row per entry in `names`, top to bottom. Only the count matters, the name is on the card. Add a name, the box grows a row. Every extra button needs its own GPIO pin and its own two jumpers.

Measure before printing, all marked MEASURE in the source: the relay module's PCB, height, and bare edge strip; the OTG adapter and mic as one plugged-in chain; the camera's lens height and lens center; the button behind the plates with jumpers on.

Print:

- Tub: as the STL opens, open side up. No supports.
- Backplate: as the STL opens, face on the bed. No supports.
- Panel: as the STL opens, face up. No supports. Iron the top layer for a smooth face.
- 0.2mm layers, PLA. Dry the spool.
- Regenerate after edits:
  `openscad -o gate-box-tub.stl gate-box.scad`
  `openscad -D 'part="lid"' -o gate-box-lid.stl gate-box.scad`
  `openscad -D 'part="face"' -o gate-box-face.stl gate-box.scad`
- Preview with `part="assembly"`: dummy volumes for every part, and the derived sizes echo to the console.

Assembly:

- Screw the tub to the wall, four screws through the back.
- Press four pegs into the Pi sockets, board on, header toward you.
- Relay into the cradle, PCB on the corner pads.
- Power cable in through the bottom slot, plug into PWR. OTG adapter with the mic into USB, mic tip down.
- Camera on the backplate posts, ribbon down and to the Pi's right edge.
- Button through both plates, nut behind the backplate.
- Jumpers: F-F on the Pi, F-M on the relay and the button, join the ends.
- Clear sheet, then the card, into the pocket on the panel's back. Backplate on the tub, panel on the backplate, four M3 screws.

Fit:

- Skirt over the tub: `clr`. Relay play in the cradle: `relay_clr`. Pillar gap over the relay: the 0.5 in `pillar_h`. Lens depth in the window: `cam_recess`. Card in the pocket: `label_pocket_d`. One variable per reprint.
