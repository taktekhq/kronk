// Saddle tray for the Raspberry Pi 5, v2. Tool free, no screws.
// Rests on the LDNIO Z11 socket extender and the Cudy AC1200 (RE1200)
// WiFi extender plugged into the Z11's right face.
//
// v1 fit test: the Z11 skirt fit is right. The arm was wrong, it
// reached for the Cudy's far edge and ran into the antennas standing
// there. The edge grips were wrong, they hit the power button and the
// ports. v2 lands the foot just past the plug hump, well before the
// antennas, and mounts the Pi on four pegs in its mounting holes,
// nothing touches the board edges.
//
// Frame: X runs along the wall, left to right. Y runs away from the
// wall. Z up. Origin: left wall-side corner of the Z11 top face, Z=0
// at the Z11 top plane. The plate caps the Z11, a skirt grips three
// cube sides, a short arm crosses the Cudy plug hump and a foot steps
// down onto the flat just past it.
//
// Pi mount: drop the board onto the four pegs, holes over pegs, and
// press. Two diagonal pegs are slightly fat for friction. Lift to
// remove. Pads under the holes give 3mm of air for the microSD card
// and the solder side.
//
// Print: upright, as modeled, skirt and foot on the bed. Supports ON:
// tree, build plate only. They fill the skirt cavity and the space
// under the arm and pop out; the top surfaces stay clean.
// Bambu Lab A1 Mini, PLA. Stringing is filament, not the model: dry
// the PLA, tune retraction.
// Regenerate STL: openscad -o pi5-saddle.stl pi5-saddle.scad
//
// Test fit. Rocking between cube and foot: tune cudy_drop. Tight or
// loose on the cube: tune clr. Pegs tight or loose in the board:
// tune peg_d and peg_extra. Foot not on clear flat: tune arm_len.

clr = 0.5;        // clearance added around measured device sizes
wall = 2.5;       // skirt wall thickness
plate_t = 4;      // tray plate thickness

// LDNIO Z11, confirmed by the v1 fit
z11 = 50;         // cube top, both directions
skirt_drop = 10;  // skirt depth down the cube sides

// Cudy AC1200
cudy_hump = 16;   // plug hump length before the flat zone
cudy_drop = 10;   // Cudy flat top sits this far below the Z11 top
arm_len = 26;     // arm length past the cube face; the foot lands at
                  // its end, just past the hump, clear of the antennas
foot_t = 4;       // foot wall thickness

// Raspberry Pi 5, long side parallel to the wall
pi_l = 85;
pi_w = 56;
hole_dx = 58;     // official mounting hole pattern, holes 3.5 from edges
hole_dy = 49;
pad_d = 7;        // standoff pad under each hole
pad_h = 3;        // board sits this far above the plate
peg_d = 2.4;      // peg diameter; board holes are 2.7
peg_extra = 0.15; // added to two diagonal pegs for friction
peg_h = 3.5;      // straight peg length above the pad, plus a cone tip

// zip tie anchors, fallback only
slot_l = 5;
slot_w = 3;

eps = 0.01;
$fn = 48;

// derived
plat_x0 = -(clr + wall);          // platform outer left edge
plat_y0 = -(clr + wall);          // platform outer wall-side edge
plat_y1 = z11 + clr + wall;       // platform outer room-side edge
arm_x0 = z11 + clr;               // arm starts at the cube's right face
arm_x1 = arm_x0 + arm_len;        // arm end, foot outer face

pi_x0 = 7.5;                      // board left edge
pi_y0 = z11/2 - pi_w/2;
holes = [[pi_x0 + 3.5, pi_y0 + 3.5], [pi_x0 + 3.5 + hole_dx, pi_y0 + 3.5],
         [pi_x0 + 3.5, pi_y0 + 3.5 + hole_dy],
         [pi_x0 + 3.5 + hole_dx, pi_y0 + 3.5 + hole_dy]];

difference() {
    union() {
        // one full width plate, platform and arm
        translate([plat_x0, plat_y0, 0])
            cube([arm_x0 - plat_x0, plat_y1 - plat_y0, plate_t]);
        translate([arm_x0 - eps, pi_y0, 0])
            cube([arm_x1 - arm_x0 + eps, pi_w, plate_t]);
        // skirt, three sides: left, wall side, room side; right stays open
        translate([plat_x0, plat_y0, -skirt_drop])
            cube([wall, plat_y1 - plat_y0, skirt_drop + eps]);
        translate([plat_x0, plat_y0, -skirt_drop])
            cube([z11 - plat_x0, wall, skirt_drop + eps]);
        translate([plat_x0, plat_y1 - wall, -skirt_drop])
            cube([z11 - plat_x0, wall, skirt_drop + eps]);
        // foot, drops onto the Cudy flat just past the hump
        translate([arm_x1 - foot_t, pi_y0, -cudy_drop])
            cube([foot_t, pi_w, cudy_drop + eps]);

        // pegs: pad, straight peg, cone tip; two diagonals run fat
        for (i = [0:3]) {
            fat = (i == 0 || i == 3) ? peg_extra : 0;
            translate([holes[i][0], holes[i][1], plate_t - eps]) {
                cylinder(d = pad_d, h = pad_h + eps);
                translate([0, 0, pad_h])
                    cylinder(d = peg_d + fat, h = peg_h + eps);
                translate([0, 0, pad_h + peg_h])
                    cylinder(d1 = peg_d + fat, d2 = 1.2, h = 1);
            }
        }
    }

    // vent window under the board center
    translate([16, 6, -eps]) cube([46, z11 - 12, plate_t + 2*eps]);

    // zip tie slots in the three skirts, one loop around the cube
    translate([plat_x0 - eps, z11/2 - slot_l/2, -6.5])
        cube([wall + 2*eps, slot_l, slot_w]);
    translate([z11/2 - slot_l/2, plat_y0 - eps, -6.5])
        cube([slot_l, wall + 2*eps, slot_w]);
    translate([z11/2 - slot_l/2, plat_y1 - wall - eps, -6.5])
        cube([slot_l, wall + 2*eps, slot_w]);

    // zip tie notches on the arm edges, one loop around arm and Cudy
    translate([66, pi_y0 - eps, -eps]) cube([slot_w, 2, plate_t + 2*eps]);
    translate([66, pi_y0 + pi_w - 2 + eps, -eps])
        cube([slot_w, 2, plate_t + 2*eps]);
}
