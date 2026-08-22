// Saddle tray for the Raspberry Pi 5, v11. Tool free, no screws.
//
// v11: expansion pegs, all four identical. Two of the Pi's holes are
// covered above, a snap barb cannot click open there and breaks when
// forced. The grip moved inside the bore: the split pin is 2.9 wide
// across a 2.7 hole, the halves compress on the way in and press the
// bore by spring, snug on every hole, nothing pops out above the
// board, nothing to break.
//
// v10: the v8 prongs pulled out too easily, 4.5 wide and only 8mm past
// the socket face. Now they match the European convention, 4.8 wide
// with 19mm engagement, and lean toward each other like a Europlug's
// converging pins so the socket bends them straight and grips.
//
// v9: snap pegs. The v5 pegs sat loose in their sockets and the Pi
// lifted off freely. The pegs are now split snap pins like the Pi
// active cooler's: the barbed tip squeezes through the board's hole
// and clicks open above it, and the fatter split shaft squeezes snug
// into the saddle socket. Remove the board with a firm straight pull,
// or pinch the tips.
// Plugs into the top socket of the LDNIO Z11 socket extender and
// carries the Pi over it and the Cudy AC1200 (RE1200) beside it.
//
// v8: the plug carries everything. Two solid prongs on a round base,
// shaped like a plug face, enter the cube's top socket; the base nests
// in the round well, the contacts grip the prongs. The Cudy foot is
// gone, the arm just cantilevers over it. The skirt walls are short
// alignment guides now, left and room side only. SAFETY: prongs and
// base are solid plastic and must stay that way, no metal, no foil,
// no hollow prongs.
//
// Pegs: separate press-in parts. The saddle top is flat, so it prints
// upside down, top face on the bed, no supports, no bridges. Press
// the four pegs into the Pi's mounting holes first, then drop board
// and pegs into the saddle's sockets; the board's weight traps the
// flanges.
//
// Two parts from this one file:
//   openscad -o pi5-saddle.stl pi5-saddle.scad            (print ready, flipped)
//   openscad -D 'part="pegs"' -o pi5-pegs.stl pi5-saddle.scad
// Set part="assembly" to preview everything upright with pegs seated.
//
// MEASURE, top socket of the cube: hole spacing (prong_gap), well
// depth to the socket face (well_depth), well diameter (base_d must
// stay under it), and whether the two holes line up wall-to-room
// (prong_along_y) or along the wall.
//
// Print: saddle exactly as the STL opens, flat face on the bed, no
// supports. Pegs standing, add a brim. 0.2mm, PLA, dry the spool.
//
// Fit tuning, one variable per reprint: cube grip, clr. Pin in the
// board holes, pin_d. Peg in the saddle, socket_d. Prong grip in the
// socket, prong_d. Base in the well, base_d.

part = "saddle";  // "saddle" | "pegs" | "assembly"

clr = 0;          // extra clearance around the cube; the printed 51.0
                  // cavity fit the 51 cube well, raise only if a
                  // reprint runs tight
wall = 2.5;       // skirt wall thickness
plate_t = 4;      // tray plate thickness

// LDNIO Z11, measured 5.1cm each way, fit confirmed on the wall
z11 = 51;         // cube top, both directions
skirt_drop = 4;   // short guide walls; the prongs do the locking

// Cudy AC1200
arm_len = 42;     // arm past the cube face, ends at the board's edge,
                  // cantilevers over the Cudy, no foot

// prongs into the cube's top socket, solid plastic only.
// European convention: pins are 4.8 thick and engage 19 deep, the
// socket's grip springs sit well behind the face. The prongs also
// lean toward each other like a Europlug's converging pins: the
// socket bends them straight and the springback grips.
prong_d = 4.8;    // standard pin diameter; drop to 4.6 if insertion fights
prong_gap = 19;   // hole spacing, center to center, confirmed by v8
well_depth = 4;   // cube top surface down to the socket face, measured
engage = 19;      // standard pin engagement below the socket face
prong_lean = 0.5; // each tip pulls this much toward center; more lean,
                  // more grip; 0 is a parallel Schuko pin
prong_along_y = true; // holes line up wall-to-room, confirmed by v8
base_d = 37.4;    // round base fills the measured 38 well, 0.6 clearance
base_h = 3.8;     // almost the full 4 well depth; 0.2 shy so the plate
                  // still seats on the cube top, the base bears just after

// Raspberry Pi 5, long side parallel to the wall
pi_l = 85;
pi_w = 56;
hole_dx = 58;     // official mounting hole pattern, holes 3.5 from edges
hole_dy = 49;

// pegs, printed separately, all four identical. Split expansion
// pins: the pin is wider than the board's hole and the split lets the
// halves compress into it, spring friction grips inside the bore. The
// flex lives in the long split, which keeps PLA inside its elastic
// range. The tip barely clears the board's top face, so holes with
// covered tops take the peg like open ones.
pin_d = 2.9;      // expansion width across the split; the hole is 2.7
pcb_t = 1.6;      // Pi board thickness the pin grips through
grip_h = 1.2;     // straight grip section inside the bore
lead_h = 1.2;     // cone lead above it, ends 0.8 past the board top
seat_l = 7;       // seat bar the board rests on, along the split
seat_w = 2.6;     // seat bar width
seat_h = 3;       // air under the board, clears the microSD card
split_w = 1.1;    // the split; the halves flex toward each other
shaft_d = 4.2;    // shaft into the saddle socket, snug, and the split
                  // lets it squeeze in
shaft_h = 2.9;    // a touch shorter than the socket
socket_d = 4.3;   // socket in the plate
socket_h = 3;     // blind, 1mm floor keeps the underside clean

// zip tie anchors on the arm, fallback only
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

module saddle() {
    difference() {
        union() {
            // one full width plate, platform and arm, flat top
            translate([plat_x0, plat_y0, 0])
                cube([arm_x0 - plat_x0, plat_y1 - plat_y0, plate_t]);
            translate([arm_x0 - eps, pi_y0, 0])
                cube([arm_x1 - arm_x0 + eps, pi_w, plate_t]);
            // short guide walls, left and room side. Wall side stays
            // open, the outlet's raised edge lives there. Right stays
            // open for the Cudy.
            translate([plat_x0, plat_y0, -skirt_drop])
                cube([wall, plat_y1 - plat_y0, skirt_drop + eps]);
            translate([plat_x0, plat_y1 - wall, -skirt_drop])
                cube([z11 - plat_x0, wall, skirt_drop + eps]);
            // round base nesting in the socket well, prongs from its
            // face, the whole thing shaped like a plug: hold-down and
            // lateral lock. Solid plastic, cone tips for the lead-in.
            translate([z11/2, z11/2, -base_h])
                cylinder(d = base_d, h = base_h + eps);
            for (s = [-1, 1]) {
                px = z11/2 + (prong_along_y ? 0 : s*prong_gap/2);
                py = z11/2 + (prong_along_y ? s*prong_gap/2 : 0);
                bx = z11/2 + (prong_along_y ? 0 : s*(prong_gap/2 - prong_lean));
                by = z11/2 + (prong_along_y ? s*(prong_gap/2 - prong_lean) : 0);
                zb = -(well_depth + engage);
                hull() {
                    translate([px, py, -1]) cylinder(d = prong_d, h = 1 + eps);
                    translate([bx, by, zb + 1.5]) cylinder(d = prong_d, h = 0.5);
                }
                translate([bx, by, zb]) cylinder(d1 = 2.4, d2 = prong_d, h = 1.5 + eps);
            }
        }

        // blind sockets for the pegs, open from the top
        for (h = holes)
            translate([h[0], h[1], plate_t - socket_h])
                cylinder(d = socket_d, h = socket_h + eps);

        // vent window under the board, beside the base
        translate([44, z11/2 - 19.5, -eps]) cube([18, 39, plate_t + 2*eps]);

        // zip tie notches on the arm edges, one loop around arm and Cudy
        translate([66, pi_y0 - eps, -eps]) cube([slot_w, 2, plate_t + 2*eps]);
        translate([66, pi_y0 + pi_w - 2 + eps, -eps])
            cube([slot_w, 2, plate_t + 2*eps]);
    }
}

// one peg, standing as printed: chamfered shaft, seat bar, expansion
// pin with cone lead, all split lengthwise so the halves can flex
module peg() {
    difference() {
        union() {
            cylinder(d1 = 3.4, d2 = shaft_d, h = 0.8);
            translate([0, 0, 0.8 - eps])
                cylinder(d = shaft_d, h = shaft_h - 0.8 + eps);
            translate([-seat_l/2, -seat_w/2, shaft_h - eps])
                cube([seat_l, seat_w, seat_h + eps]);
            translate([0, 0, shaft_h + seat_h - eps])
                cylinder(d = pin_d, h = grip_h + 2*eps);
            translate([0, 0, shaft_h + seat_h + grip_h])
                cylinder(d1 = pin_d, d2 = 1.5, h = lead_h);
        }
        // the split, from just above the shaft base to past the tip
        translate([-seat_l/2 - 1, -split_w/2, 1.5])
            cube([seat_l + 2, split_w, shaft_h + seat_h + grip_h + lead_h]);
    }
}

if (part == "saddle") {
    // flipped, print ready: flat top on the bed
    rotate([180, 0, 0]) saddle();
} else if (part == "pegs") {
    // four pegs plus four spares, standing, print with a brim
    for (i = [0:7])
        translate([12*(i%4), 12*floor(i/4), 0]) peg();
} else {
    // assembly preview, upright, pegs seated in their sockets
    saddle();
    for (h = holes)
        translate([h[0], h[1], plate_t - shaft_h]) peg();
}
