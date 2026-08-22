// Saddle tray for the Raspberry Pi 5, v8. Tool free, no screws.
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

// prongs into the cube's top socket, solid plastic only
prong_d = 4.5;    // socket pins are 4.8, printed PLA runs a bit fat
prong_gap = 19;   // hole spacing, center to center // MEASURE
well_depth = 9;   // cube top surface down to the socket face // MEASURE
engage = 8;       // how deep the prongs enter the holes
prong_along_y = true; // holes line up wall-to-room; false: along the wall // MEASURE
base_d = 30;      // round base around the prongs, nests in the socket
                  // well like a plug face; keep under the well diameter // MEASURE
base_h = 3;       // base depth into the well

// Raspberry Pi 5, long side parallel to the wall
pi_l = 85;
pi_w = 56;
hole_dx = 58;     // official mounting hole pattern, holes 3.5 from edges
hole_dy = 49;

// pegs, printed separately
pin_d = 2.45;     // pin through the board's 2.7 holes, light friction
pin_h = 3;        // straight pin above the flange, plus a cone tip
flange_d = 7;     // standoff flange, board rests on it
flange_h = 3;     // air under the board, clears the microSD card
shaft_d = 4;      // shaft into the saddle socket
shaft_h = 2.8;    // a touch shorter than the socket
socket_d = 4.3;   // socket in the plate, loose drop-in fit
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
                translate([px, py, -(well_depth + engage) + 1.5 - eps])
                    cylinder(d = prong_d, h = well_depth + engage - 1.5 + 2*eps);
                translate([px, py, -(well_depth + engage)])
                    cylinder(d1 = 2.5, d2 = prong_d, h = 1.5 + eps);
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

// one peg, standing as printed: shaft, flange, pin, cone tip
module peg() {
    cylinder(d = shaft_d, h = shaft_h);
    translate([0, 0, shaft_h]) cylinder(d = flange_d, h = flange_h);
    translate([0, 0, shaft_h + flange_h]) cylinder(d = pin_d, h = pin_h);
    translate([0, 0, shaft_h + flange_h + pin_h])
        cylinder(d1 = pin_d, d2 = 1.2, h = 1);
}

if (part == "saddle") {
    // flipped, print ready: flat top on the bed
    rotate([180, 0, 0]) saddle();
} else if (part == "pegs") {
    // four pegs plus two spares, standing, print with a brim
    for (i = [0:5])
        translate([12*(i%3), 12*floor(i/3), 0]) peg();
} else {
    // assembly preview, upright, pegs seated in their sockets
    saddle();
    for (h = holes)
        translate([h[0], h[1], plate_t - shaft_h]) peg();
}
