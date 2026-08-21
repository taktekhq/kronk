// Saddle tray for the Raspberry Pi 5. Tool free, no screws.
// Rests on the LDNIO Z11 socket extender and the Cudy AC1200 (RE1200)
// WiFi extender plugged into the Z11's right face.
//
// Frame: X runs along the wall, left to right. Y runs away from the wall.
// Z up. Origin: left wall-side corner of the Z11 top face, Z=0 at the
// Z11 top plane. The plate caps the Z11, a skirt grips three cube sides,
// an arm crosses over the Cudy plug hump and a foot steps down onto its
// flat top, between the antennas.
//
// Pi mount, slide-in: edge ribs lift the board 3mm, side guide walls set
// it straight, two pockets hook over the board's left edge, a spring
// latch clicks behind the right edge. Press the latch tab down, slide
// the board right, it is out. The pocket gap avoids the microSD card.
// Orient the Pi with the USB-C edge facing the room, ports edge right.
//
// Antennas: flared notches on the arm sides nest around the antenna
// bases as lateral guides only. The antennas carry no vertical load.
//
// Print: upright, as modeled, skirt and foot on the bed. No supports;
// the plate underside prints as bridges, hidden in use. Bambu Lab A1
// Mini, PLA. Regenerate STL: openscad -o pi5-saddle.stl pi5-saddle.scad
//
// Test fit first. Rocking: tune cudy_drop. Tight or loose on the cube:
// tune clr. Latch too stiff or weak: tune nub_h. One variable, one
// reprint.

clr = 0.5;        // clearance added around measured device sizes
wall = 2.5;       // skirt, foot, and pocket wall thickness
plate_t = 4;      // tray plate thickness

// LDNIO Z11, measured
z11 = 50;         // cube top, both directions; whole cube 50x50x50
skirt_drop = 10;  // skirt depth down the cube sides; equals cudy_drop so the print sits flat on the bed

// Cudy AC1200, measured plugged into the Z11's right face
cudy_hump = 16;   // plug hump length before the flat zone; its top must stay below the Z11 top
cudy_flat = 38;   // usable flat length on the Cudy top
cudy_drop = 10;   // Cudy flat top sits this far below the Z11 top
arm_w = 54;       // arm width at the antennas; the gap is 58, keep under 55

// antenna guide notches, tune after the first fit
notch_r = 10;     // flare radius
notch_bite = 4;   // how deep the flare cuts into the arm edge
ant_x = 85.5;     // notch center along X, default mid flat zone

// Raspberry Pi 5, long side parallel to the wall
pi_l = 85;
pi_w = 56;
pcb_t = 1.8;      // board thickness
pcb_tol = 0.3;    // slide clearance, sides and top
rib_h = 3;        // standoff under the board, clears the microSD card

// latch
nub_h = 1.2;      // how far the nub rises above the board's seating plane
tab_t = 1;        // spring tab thickness

// zip tie anchors, fallback only, skip the ties if the fit is snug
slot_l = 5;
slot_w = 3;

ch = 3;           // chamfer cut size on the arm's lower edges
eps = 0.01;
$fn = 48;

// derived
plat_x0 = -(clr + wall);          // platform outer left edge
plat_y0 = -(clr + wall);          // platform outer wall-side edge
plat_y1 = z11 + clr + wall;       // platform outer room-side edge
arm_x0 = z11 + clr;               // arm starts at the cube's right face
arm_x1 = arm_x0 + cudy_hump + cudy_flat;  // arm ends at the far edge of the flat
arm_y0 = z11/2 - arm_w/2;
arm_y1 = z11/2 + arm_w/2;
wide_x1 = 66;                     // guide wall section ends before the antennas
wide_y0 = arm_y0 - 3.5;           // wider arm section under the guide walls
wide_y1 = arm_y1 + 3.5;

pi_x0 = 7.5;                      // board left edge; the pocket stop sets this
pi_y0 = z11/2 - pi_w/2;
pi_top = plate_t + rib_h + pcb_t; // board top surface
lip_z = pi_top + pcb_tol;         // pocket lip underside
nub_x = pi_x0 + pi_l + pcb_tol;   // latch nub face behind the board

difference() {
    union() {
        // platform plate over the Z11
        translate([plat_x0, plat_y0, 0])
            cube([arm_x0 - plat_x0, plat_y1 - plat_y0, plate_t]);
        // arm plate, wide under the guide walls, narrow past the antennas
        translate([arm_x0 - eps, wide_y0, 0])
            cube([wide_x1 - arm_x0 + eps, wide_y1 - wide_y0, plate_t]);
        translate([wide_x1 - eps, arm_y0, 0])
            cube([arm_x1 - wide_x1 + eps, arm_w, plate_t]);
        // skirt, three sides: left, wall side, room side; right stays open
        translate([plat_x0, plat_y0, -skirt_drop])
            cube([wall, plat_y1 - plat_y0, skirt_drop + eps]);
        translate([plat_x0, plat_y0, -skirt_drop])
            cube([z11 - plat_x0, wall, skirt_drop + eps]);
        translate([plat_x0, plat_y1 - wall, -skirt_drop])
            cube([z11 - plat_x0, wall, skirt_drop + eps]);
        // foot, drops onto the Cudy flat top
        translate([arm_x1 - wall, arm_y0, -cudy_drop])
            cube([wall, arm_w, cudy_drop + eps]);

        // edge ribs the board slides on, outside the GPIO pin rows,
        // stopping short of the antenna notch flares
        translate([pi_x0 + 0.5, pi_y0, plate_t - eps])
            cube([66, 2, rib_h + eps]);
        translate([pi_x0 + 0.5, pi_y0 + pi_w - 2, plate_t - eps])
            cube([66, 2, rib_h + eps]);
        // rib pads under the board's right end
        for (y = [pi_y0 + 7, pi_y0 + pi_w - 15])
            translate([84, y, plate_t - eps]) cube([6, 8, rib_h + eps]);

        // side guide walls, no lips, clear of every connector
        for (y = [pi_y0 - pcb_tol - 1.8, pi_y0 + pi_w + pcb_tol])
            translate([54, y, plate_t - eps]) cube([12, 1.8, 5 + eps]);

        // left pockets: stop wall plus lip over the board edge,
        // split so the microSD card zone stays open
        for (y = [pi_y0 + 11, pi_y0 + 37])
            translate([pi_x0 - pcb_tol - wall, y, plate_t - eps]) {
                cube([wall, 8, lip_z + 1.9 - plate_t + eps]);
                translate([0, 0, lip_z - plate_t])
                    cube([wall + 3, 8, 1.9 + eps]);
            }

        // latch nub on the spring tab, vertical face left, ramp right
        hull() {
            translate([nub_x, 21, plate_t - eps])
                cube([1, 8, rib_h + nub_h + eps]);
            translate([nub_x, 21, plate_t - eps])
                cube([3.2, 8, rib_h + eps]);
        }
    }

    // vent windows under the board, also thumb access from below
    translate([16, 6, -eps]) cube([47, z11 - 12, plate_t + 2*eps]);
    translate([68, 8, -eps]) cube([7, 34, plate_t + 2*eps]);

    // spring tab: U slot around it, thinned from below
    translate([78, 19, -1]) cube([22, 1.5, plate_t + 6]);
    translate([78, 29.5, -1]) cube([22, 1.5, plate_t + 6]);
    translate([98.5, 19, -1]) cube([1.5, 12, plate_t + 6]);
    translate([78, 20.5 - eps, -eps]) cube([20.5 + eps, 9 + 2*eps, plate_t - tab_t + eps]);

    // zip tie slots in the three skirts, one loop around the cube
    translate([plat_x0 - eps, z11/2 - slot_l/2, -6.5])
        cube([wall + 2*eps, slot_l, slot_w]);
    translate([z11/2 - slot_l/2, plat_y0 - eps, -6.5])
        cube([slot_l, wall + 2*eps, slot_w]);
    translate([z11/2 - slot_l/2, plat_y1 - wall - eps, -6.5])
        cube([slot_l, wall + 2*eps, slot_w]);

    // zip tie notches on the arm edges, one loop around arm and Cudy
    translate([68, arm_y0 - eps, -eps]) cube([slot_w, 2, plate_t + 2*eps]);
    translate([68, arm_y1 - 2 + eps, -eps]) cube([slot_w, 2, plate_t + 2*eps]);

    // antenna guide notches, flares that nest around the antenna bases
    for (y = [z11/2 - (arm_w/2 + notch_r - notch_bite),
              z11/2 + (arm_w/2 + notch_r - notch_bite)])
        translate([ant_x, y, -1]) cylinder(r = notch_r, h = plate_t + 2);

    // chamfer the arm's lower edges so it threads between the antennas
    for (y = [arm_y0, arm_y1])
        translate([(wide_x1 + arm_x1)/2, y, 0])
            rotate([45, 0, 0])
                cube([arm_x1 - wide_x1 + 2*eps, ch, ch], center = true);
}
