// Saddle tray for the Raspberry Pi 5, v3. Tool free, no screws.
// Rests on the LDNIO Z11 socket extender and the Cudy AC1200 (RE1200)
// WiFi extender plugged into the Z11's right face.
//
// v1 fit test: the Z11 skirt fit is right, everything else was wrong.
// A top photo then decoded the Cudy: the antennas are fold flat
// paddles splayed at the far end of its top, their hinges eat that far
// end. So: no notches, no chamfers, the arm runs full width. The foot
// lands 45mm out, mid flat, clear of the hinges. Two through slots in
// the arm let the raised paddles pass and key the saddle against
// sliding, no load on the hinges.
//
// Pi mount: four pegs in the board's mounting holes, the only spots on
// a Pi 5 guaranteed free of parts. v1's edge grips hit the power
// button and the ports; nothing touches the board edges now. Drop the
// board on, press; two diagonal pegs run fat for friction; lift off.
//
// MEASURE BEFORE PRINTING, placeholder paddle numbers below:
//   paddle_x     distance, cube face to paddle center
//   paddle_span  distance between the two paddle centers
//   paddle_w, paddle_t  one paddle's width and thickness
//
// Print: upright, as modeled, skirt and foot on the bed. Do not
// rotate. Supports: tree, build plate only, they fill the skirt cavity
// and under the arm and pop out. Dry the PLA first, the stringing was
// moisture. Bambu Lab A1 Mini, 0.2mm.
// Regenerate STL: openscad -o pi5-saddle.stl pi5-saddle.scad
//
// Fit tuning, one variable per reprint: rocking, cudy_drop. Cube grip,
// clr. Peg fit, peg_d and peg_extra. Foot placement, foot_x.

clr = 0.5;        // clearance added around measured device sizes
wall = 2.5;       // skirt wall thickness
plate_t = 4;      // tray plate thickness

// LDNIO Z11, confirmed by the v1 fit
z11 = 50;         // cube top, both directions
skirt_drop = 10;  // skirt depth down the cube sides

// Cudy AC1200
cudy_drop = 10;   // Cudy flat top sits this far below the Z11 top
arm_len = 58;     // arm length past the cube face, spans the whole top
foot_x = 42;      // foot lands here, from the cube face: mid flat,
                  // past the 16mm plug hump, fully clear of the
                  // paddle slots so raised paddles never hit the foot
foot_t = 4;       // foot wall thickness

// antenna paddles, raised through the arm // MEASURE all four
paddle_x = 48;    // cube face to paddle center
paddle_span = 36; // between the two paddle centers, across the arm
paddle_w = 14;    // paddle width, slot gets +4
paddle_t = 9;     // paddle thickness, slot gets +3

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
arm_x1 = arm_x0 + arm_len;        // arm end, past the paddle slots

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
        // foot, drops onto the Cudy flat mid way, clear of the hinges
        translate([arm_x0 + foot_x - foot_t, pi_y0, -cudy_drop])
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

    // paddle slots: raised antennas pass through the arm and key the
    // saddle in place, loose fit, zero load on the hinges
    for (s = [-1, 1])
        translate([arm_x0 + paddle_x - (paddle_t + 3)/2,
                   z11/2 + s*paddle_span/2 - (paddle_w + 4)/2, -1])
            cube([paddle_t + 3, paddle_w + 4, plate_t + 2]);

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
