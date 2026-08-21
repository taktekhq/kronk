// Saddle tray for the Raspberry Pi 5, v5. Tool free, no screws.
// Rests on the LDNIO Z11 socket extender and the Cudy AC1200 (RE1200)
// WiFi extender plugged into the Z11's right face.
//
// v5: the pegs are separate press-in parts. The saddle top is flat, so
// it prints upside down, top face on the bed, no supports, no bridges.
// Press the four pegs into the Pi's mounting holes first, then drop
// board and pegs into the saddle's sockets. The peg flange is captured
// between board and plate, the pegs cannot fall out while the board
// sits on them.
//
// Cudy topology, photo corrected: the antennas hinge at the SIDES of
// the body near its far end and splay outward at body level. Open
// notches on the arm's side edges give them room; the foot's far face
// butts the hinge fronts and stops the saddle sliding off the open
// side. The left skirt wall stops the other direction.
//
// Two parts from this one file:
//   openscad -o pi5-saddle.stl pi5-saddle.scad            (print ready, flipped)
//   openscad -D 'part="pegs"' -o pi5-pegs.stl pi5-saddle.scad
// Set part="assembly" to preview everything upright with pegs seated.
//
// MEASURE: hinge_x, cube face to the front of the antenna hinges.
//
// Print: saddle exactly as the STL opens, flat face on the bed, no
// supports. Pegs standing, add a brim. 0.2mm, PLA, dry the spool.
//
// Fit tuning, one variable per reprint: rocking, cudy_drop. Cube grip,
// clr. Pin in the board holes, pin_d. Peg in the saddle, socket_d.
// Foot placement, hinge_x.

part = "saddle";  // "saddle" | "pegs" | "assembly"

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

// pegs, printed separately
pin_d = 2.45;     // pin through the board's 2.7 holes, light friction
pin_h = 3;        // straight pin above the flange, plus a cone tip
flange_d = 7;     // standoff flange, board rests on it
flange_h = 3;     // air under the board, clears the microSD card
shaft_d = 4;      // shaft into the saddle socket
shaft_h = 2.8;    // a touch shorter than the socket
socket_d = 4.3;   // socket in the plate, loose drop-in fit
socket_h = 3;     // blind, 1mm floor keeps the underside clean

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

module saddle() {
    difference() {
        union() {
            // one full width plate, platform and arm, flat top
            translate([plat_x0, plat_y0, 0])
                cube([arm_x0 - plat_x0, plat_y1 - plat_y0, plate_t]);
            translate([arm_x0 - eps, pi_y0, 0])
                cube([arm_x1 - arm_x0 + eps, pi_w, plate_t]);
            // skirt, three sides: left, wall side, room side; right open
            translate([plat_x0, plat_y0, -skirt_drop])
                cube([wall, plat_y1 - plat_y0, skirt_drop + eps]);
            translate([plat_x0, plat_y0, -skirt_drop])
                cube([z11 - plat_x0, wall, skirt_drop + eps]);
            translate([plat_x0, plat_y1 - wall, -skirt_drop])
                cube([z11 - plat_x0, wall, skirt_drop + eps]);
            // foot on the clear flat, far face against the hinge fronts
            translate([arm_x0 + hinge_x - foot_t, pi_y0, -cudy_drop])
                cube([foot_t, pi_w, cudy_drop + eps]);
        }

        // blind sockets for the pegs, open from the top
        for (h = holes)
            translate([h[0], h[1], plate_t - socket_h])
                cylinder(d = socket_d, h = socket_h + eps);

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
