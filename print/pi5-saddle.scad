// Saddle tray for the Raspberry Pi 5, v14. Tool free, no screws.
//
// v14: rivet pegs, both ends. The v13 solid shaft in a friction bore
// was impossible to press in, printed holes shrink and a solid shaft
// cannot give. The bore is now a clearance fit and the peg is a
// double-ended rivet: the bottom barb clicks into a counterbore
// hidden inside the plate's underside, flush, nothing protruding, and
// the top barb clicks through the Pi's hole as before. Two crossed
// splits give each barb its own long flex, overlapping mid-peg where
// the four quadrants stay joined. Push to click, both ends.
//
// v13: vented sockets, clean arm, stronger pegs. The whole blind
// sockets trapped air under the entering shaft and broke pegs; the
// sockets are now open through the plate bottom so the air escapes
// below, ring uncut, all four identical. The shaft is shorter than
// the plate, nothing pokes out underneath. The zip tie notches are
// gone, the arm is a uniform rectangle, the plug is the only anchor.
// The peg split no longer runs through the shaft: a solid shaft takes
// the socket press, the split spans only seat and pin where the barb
// needs to flex.
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

// pegs, printed separately: double-ended rivets, push to click at
// both ends. Crossed splits keep each barb's flex long and PLA-safe.
pin_d = 2.5;      // pin through the board's 2.7 holes
pcb_t = 1.6;      // Pi board thickness, the barb catches just above
barb_d = 3.1;     // barb over the 2.7 hole, 0.2 catch per side
barb_h = 0.3;     // the flat catch ledge
tip_h = 1.8;      // cone above the barb, the squeeze-in lead
seat_l = 7;       // seat bar the board rests on, along the split
seat_w = 2.6;     // seat bar width
seat_h = 3;       // air under the board, clears the microSD card
split_w = 1.1;    // the top split; the halves flex toward each other
socket_d = 4.6;   // bore through the plate, clearance fit, the air
                  // escapes below and nothing rubs
anchor_d = 4.8;   // bottom barb, clicks into the counterbore
cb_d = 5.8;       // counterbore in the plate's underside, hides the barb
cb_h = 1.1;       // counterbore depth; the barb sits inside, flush
shaft_d = 4;      // shaft, free slide in the bore

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

        // peg sockets: clearance bore through the plate with a
        // counterbore in the underside for the peg's bottom barb
        for (h = holes) {
            translate([h[0], h[1], -eps])
                cylinder(d = socket_d, h = plate_t + 2*eps);
            translate([h[0], h[1], -eps])
                cylinder(d = cb_d, h = cb_h + eps);
        }

        // vent window under the board, beside the base
        translate([44, z11/2 - 19.5, -eps]) cube([18, 39, plate_t + 2*eps]);

    }
}

// one peg, standing as printed on its flat bottom tip: a double
// ended rivet. Entry cone, bottom barb for the saddle counterbore,
// clearance shaft, seat bar, pin, top barb for the Pi's hole, tip
// cone. Two crossed splits: the bottom one is thin across X and runs
// up into the seat, the top one thin across Y from mid-shaft to the
// tip; they overlap mid-peg where the four quadrants stay joined, so
// each barb flexes on its own long spring.
module peg() {
    difference() {
        union() {
            cylinder(d1 = 3.4, d2 = anchor_d, h = 0.5);
            translate([0, 0, 0.5 - eps]) cylinder(d = anchor_d, h = 0.3 + 2*eps);
            translate([0, 0, 0.8]) cylinder(d1 = anchor_d, d2 = shaft_d, h = 0.2 + eps);
            translate([0, 0, 1 - eps]) cylinder(d = shaft_d, h = 2.9 + 2*eps);
            translate([-seat_l/2, -seat_w/2, 3.9 - eps])
                cube([seat_l, seat_w, seat_h + eps]);
            translate([0, 0, 3.9 + seat_h - eps])
                cylinder(d = pin_d, h = pcb_t + 0.1 + 2*eps);
            translate([0, 0, 3.9 + seat_h + pcb_t + 0.1])
                cylinder(d = barb_d, h = barb_h + eps);
            translate([0, 0, 3.9 + seat_h + pcb_t + 0.1 + barb_h])
                cylinder(d1 = barb_d, d2 = 1.4, h = tip_h);
        }
        // bottom split, thin across X, tip up into the seat
        translate([-0.7, -6, -eps]) cube([1.4, 12, 5.5 + eps]);
        // top split, thin across Y, mid shaft past the tip
        translate([-seat_l/2 - 1, -split_w/2, 3.5])
            cube([seat_l + 2, split_w, seat_h + pcb_t + barb_h + tip_h + 5]);
    }
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
        translate([h[0], h[1], 0.1]) peg();
}
