// Saddle tray for the Raspberry Pi 5, v4. Tool free, no screws.
// Rests on the LDNIO Z11 socket extender and the Cudy AC1200 (RE1200)
// WiFi extender plugged into the Z11's right face.
//
// Photo-corrected topology: the Cudy's antennas hinge at the SIDES of
// its body near the far end and splay OUTWARD at body level, one
// toward the wall, one toward the room. They never rise through the
// arm, so v3's through slots were wrong. v4 keys them at the arm's
// side edges instead: open notches over the hinge zone, and the foot's
// far face butts the hinge fronts, which stops the saddle sliding off
// the open side. The left skirt wall stops the other direction.
//
// Pi mount: four pegs in the board's mounting holes, the only spots on
// a Pi 5 guaranteed free of parts. Drop the board on, press; two
// diagonal pegs run fat for friction; lift off.
//
// MEASURE, placeholders below, all flagged:
//   hinge_x      cube face to the front of the antenna hinges
//   hinge_len    hinge zone length along the body
//
// Print: upright, as modeled, skirt and foot on the bed. Do not
// rotate. Supports: tree, build plate only. Dry the PLA first, the
// stringing was moisture. Bambu Lab A1 Mini, 0.2mm.
// Regenerate STL: openscad -o pi5-saddle.stl pi5-saddle.scad
//
// Fit tuning, one variable per reprint: rocking, cudy_drop. Cube grip,
// clr. Peg fit, peg_d and peg_extra. Foot placement, hinge_x.

clr = 0;          // extra clearance around the cube; the printed 51.0
                  // cavity fit the 51 cube well, raise only if a
                  // reprint runs tight
wall = 2.5;       // skirt wall thickness
plate_t = 4;      // tray plate thickness

// LDNIO Z11, measured 5.1cm each way, fit confirmed by the v1 print
z11 = 51;         // cube top, both directions
skirt_drop = 10;  // skirt depth down the cube sides

// Cudy AC1200
cudy_drop = 10;   // Cudy flat top sits this far below the Z11 top
arm_len = 52;     // arm length past the cube face, covers the body
                  // and stays inside its far edge
foot_t = 4;       // foot wall thickness
hinge_x = 30;     // cube face to the front of the antenna hinges; the
                  // foot's far face lands here // MEASURE
hinge_len = 16;   // hinge zone length, the side notches span it // MEASURE
notch_depth = 6;  // how far the side notches cut into the arm edges

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
arm_x1 = arm_x0 + arm_len;        // arm end

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
        // foot on the clear flat, far face against the hinge fronts,
        // vertical support and the stop against sliding off
        translate([arm_x0 + hinge_x - foot_t, pi_y0, -cudy_drop])
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

    // antenna notches: open cuts on both arm edges over the hinge
    // zone, room for the paddles raised or splayed, no hinge load
    for (y = [pi_y0 - eps, pi_y0 + pi_w - notch_depth + eps])
        translate([arm_x0 + hinge_x, y, -1])
            cube([hinge_len, notch_depth, plate_t + 2]);

    // vent window under the board center
    translate([16, z11/2 - 19.5, -eps]) cube([46, 39, plate_t + 2*eps]);

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
