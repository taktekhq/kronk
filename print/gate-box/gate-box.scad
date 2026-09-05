// Gate box for the Raspberry Pi Zero 2 W, v2. One name, one button.
//
// Three parts: the tub, the backplate, and the panel. The tub screws
// to the wall and carries the Pi, the relay, the mic chain, and the
// cable exits at the bottom. The backplate caps the tub with an outer
// skirt so rain runs past the seam and carries the camera and the
// relay pillars on its inside. The panel is the face: an interphone
// front with a raised bezel, corner screws, a hooded camera eye, one
// label window per name with the button in a collar beside it, seam
// lines between the modules, and a slotted grille over the mic. Four
// M3 screws from the front go through both plates into the tub's
// corner bosses.
//
// The label is a printed card behind a clear sheet, both dropped into
// a pocket on the panel's back; the backplate closes the pocket.
//
// Names: one row per entry in `names`, top to bottom. Add a name, the
// box grows a row. Every extra button needs its own GPIO pin and its
// own two jumpers.
//
// Inside, from the top: relay on the back wall with the camera on the
// backplate in front of it, the Pi with its header toward the
// backplate so the F-F jumpers plug straight in, then the USB mic on
// its OTG adapter and the power plug hanging off the Pi's bottom edge
// to the exits in the bottom wall. The button tails and the name rows
// sit beside the mic chain, over a clear stretch of back wall.
//
// The Pi mounts on the pi5-saddle rivet pegs, same bore and counterbore
// as the saddle, or on M2.5 screws with pi_mount = "screws". The relay
// sits in a corner cradle and is boxed in by four pillars from the
// backplate, nothing clips it. The camera screws to four posts on the
// backplate with M2 screws.
//
// Four outputs from this one file:
//   openscad -o gate-box-tub.stl gate-box.scad                    (upright, open side up)
//   openscad -D 'part="lid"' -o gate-box-lid.stl gate-box.scad    (backplate, flipped, face on the bed)
//   openscad -D 'part="face"' -o gate-box-face.stl gate-box.scad  (panel, face up)
//   part="assembly" previews everything with dummy volumes for the parts.
//
// MEASURE before printing, all in mm. Guesses are marked here and read
// off the real parts once: relay_l, relay_w, relay_h, relay_edge;
// otg_len and mic_len as a plugged-in chain; cam_lens_h and
// cam_lens_from_top on the Camera Module 3; btn_tail with jumpers on.
//
// Print: tub as the STL opens, no supports. Backplate as the STL
// opens, face down, no supports. Panel as the STL opens, face up, no
// supports. 0.2mm, PLA, dry the spool.

part = "tub";   // "tub" | "lid" | "face" | "assembly"

names = ["KRONK"];  // one row per name, top to bottom. Only the count
                    // matters, the name is a printed card.
row_pitch = 26;     // row to row
brand = "kronk";    // small mark on the bottom bezel, "" for none
brand_size = 2.6;
brand_font = "Liberation Sans:style=Bold";

// shell
wall = 2.5;         // side walls
back_t = 2.5;       // back wall
lid_t = 2.5;        // faceplate
D_in = 36;          // inside depth, back wall to backplate
r_out = 8;          // tub corner radius, the plates follow
clr = 0.3;          // backplate skirt over the tub walls
skirt_t = 2;        // skirt thickness
skirt_h = 6;        // how far the skirt reaches down over the walls
boss = 7;           // corner boss, square
boss_pilot_d = 2.6; // M3 self tapping into the boss
lid_thru_d = 3.4;   // M3 clearance through both plates
lid_cs_d = 6.5;     // countersink for the M3 head, in the panel

// panel, the interphone face, printed face up
face_t = 2;         // base plate
bezel_w = 5;        // raised frame around the field
bezel_h = 1.2;      // how far the frame, collars, and rings stand proud
bezel_ch = 1.2;     // chamfer on the frame's outer edge
field_r = 2;        // field corner radius, the corner screws sit there
seam_w = 1;         // module seam lines, grooves in the field
seam_d = 0.6;
cam_ring_d = 26;    // raised ring around the camera eye
cam_face_d = 13;    // eye through the panel, chamfered wide
cam_brow = [30, 3, 3];  // rain hood over the eye: width, thickness, proud of the ring
spk_grille = true;  // blind speaker grooves in the module over the Pi
spk_n = 5;
spk_l = 40;
label_frame = [68, 22]; // raised frame around the label window
label_win = [56, 13];   // what shows of the card
label_card = [61, 18];  // the printed card, and the clear sheet over it
label_pocket_d = 1;     // pocket in the panel's back, card plus sheet
btn_collar_d = 20;      // raised collar around the button
mic_slot_n = 6;         // grille over the mic, through the panel
mic_slot_l = 36;
mic_slot_w = 1.5;
mic_slot_pitch = 3.2;
mount_hole_d = 4.5; // wall screws through the back, M4 clearance
mount_in = 12;      // wall screw holes, in from the inside corners; the
                    // bottom right one steps left, clear of the button column

// Raspberry Pi Zero 2 W, official drawing. Long side horizontal,
// header at the top, SD card left, connectors along the bottom edge,
// camera connector on the right edge.
pi_l = 65;
pi_w = 30;
pi_hole_dx = 58;
pi_hole_dy = 23;
pi_hole_in = 3.5;
pi_pcb_t = 1.6;
pi_x0 = 6;          // left gap, the SD card sticks out about 2.5
pi_hdmi_x = 12.4;   // connector centers along the bottom edge
pi_usb_x = 41.4;
pi_pwr_x = 54;
pi_mount = "pegs";  // "pegs" | "screws"
pi_seat = 3;        // air under the board, both mounts

// pi5-saddle peg sockets, identical numbers: clearance bore, hidden
// counterbore for the bottom barb, bore open through the back wall so
// the air escapes. boss 4 tall like the saddle plate.
peg_boss_d = 8;
peg_boss_h = 4;
peg_socket_d = 4.6;
peg_cb_d = 5.8;
peg_cb_h = 1.1;

// screw option
pi_stand_d = 6;
pi_screw_d = 2.2;   // M2.5 self tapping

// mic chain hanging off the USB port: OTG adapter, then the mic
otg_len = 35;       // MEASURE: micro USB plug tip to the USB-A socket face
otg_w = 15;
mic_len = 25;       // MEASURE: what the mic adds past the adapter
mic_w = 20;
mic_t = 8;
chain_gap = 4;      // mic tip to the bottom wall

// power plug on the PWR port, cable straight down and out
pwr_plug_l = 20;    // overmold past the board edge
pwr_plug_w = 11;
pwr_plug_t = 8;
pwr_slot = [12, 9]; // closed slot in the bottom wall, the plug passes

// relay module, on the back wall above the Pi
relay_l = 50;       // MEASURE: PCB long side
relay_w = 26;       // MEASURE: PCB short side
relay_pcb_t = 1.6;
relay_h = 18.5;     // MEASURE: back wall side of the PCB to the top of the relay cube
relay_edge = 1.5;   // MEASURE: bare strip along the long edges, the pillars land here
relay_clr = 0.4;    // cradle play per side
relay_lift = 2.5;   // pads under the corners, room for the solder side
relay_gap = 4;      // above the Pi and below the top wall
relay_pillars = true;

// Camera Module 3, official drawing: 25 x 24, holes 21 x 12.5, M2
cam_w = 25;
cam_h = 24;
cam_hole_dx = 21;
cam_hole_dy = 12.5;
cam_hole_from_top = 2;    // top hole row, down from the board's top edge
cam_lens_from_top = 9.5;  // MEASURE: lens center, down from the top edge
cam_lens_h = 9;           // MEASURE: PCB front face to the lens front
cam_recess = 1;           // lens front sits this far behind the outer face
cam_win_d = 12;           // window, the lens barrel passes
cam_post_d = 5.5;
cam_screw_d = 1.7;        // M2 self tapping

// doorbell button, 12mm panel mount
btn_hole_d = 12.5;
btn_from_right = 12;      // button column, in from the right inside wall
btn_tail = 32;            // MEASURE: behind the faceplate with jumpers on the lugs
btn_nut_d = 16;           // nut and washer, keep-out on the inside

// bottom wall
opener_hole_d = 6;        // gate opener pair from the relay terminals
opener_from_btn = 12;     // left of the button column, clear of the nut
vent_n = 2;               // vent slots left of the mic
vent_l = 12;
vent_w = 1.6;

eps = 0.01;
$fn = 48;

// derived
n = len(names);
chain_len = otg_len + mic_len + chain_gap;
pi_y0 = max(chain_len, 61 + row_pitch*(n - 1));   // rows and the mic module need room below
pi_y1 = pi_y0 + pi_w;
ry0 = pi_y1 + relay_gap;                           // relay PCB
ry1 = ry0 + relay_w;
W_in = pi_x0 + pi_l + 25;                          // ribbon fold room on the right
H_in = ry1 + relay_gap;
rx0 = (W_in - relay_l)/2;
rx1 = rx0 + relay_l;
cam_x = W_in/2;
cam_y = (ry0 + ry1)/2;
btn_x = W_in - btn_from_right;
label_x = (-wall - clr - skirt_t + bezel_w + 2 + btn_x - btn_collar_d/2 - 2)/2;  // label frame center
function row_y(i) = pi_y0 - 22 - i*row_pitch;

pi_holes = [for (i = [0, 1], j = [0, 1])
    [pi_x0 + pi_hole_in + i*pi_hole_dx, pi_y0 + pi_hole_in + j*pi_hole_dy]];
pi_z = (pi_mount == "pegs" ? peg_boss_h : 0) + pi_seat;  // board underside
plug_z = pi_z + pi_pcb_t + 1.5;                           // micro USB plug axis

cam_top = cam_y + cam_lens_from_top;                      // board top edge
cam_holes = [for (i = [-1, 1], j = [0, 1])
    [cam_x + i*cam_hole_dx/2, cam_top - cam_hole_from_top - j*cam_hole_dy]];
cam_post_h = cam_lens_h - (lid_t - cam_recess);

relay_top = relay_lift + relay_pcb_t;                     // PCB front face
pillar_h = D_in - relay_top - 0.5;
pillar_xs = [rx0 + 8.5, rx1 - 8.5];                       // clear of the cradle and the camera board
pillar_w = 5;

boss_xy = [[boss/2, boss/2], [W_in - boss/2, boss/2],
           [boss/2, H_in - boss/2], [W_in - boss/2, H_in - boss/2]];

mic_x = pi_x0 + pi_usb_x;
pwr_x = pi_x0 + pi_pwr_x;
opener_x = btn_x - opener_from_btn;
mount_xy = [[mount_in, mount_in], [opener_x, mount_in],
            [mount_in, H_in - mount_in], [W_in - mount_in, H_in - mount_in]];

ox = wall + clr + skirt_t;                                // plate overhang past the cavity
face_z = D_in + lid_t;                                    // panel back
seams = concat([cam_y - cam_ring_d/2 - 3],
               [for (i = [0 : n - 1]) row_y(i) + row_pitch/2],
               [row_y(n - 1) - row_pitch/2]);
mic_y = (seams[n + 1] + bezel_w - ox)/2;                  // mic module center, below the last row
spk_y = (seams[0] + seams[1])/2;                          // module over the Pi

// rounded rectangle, corner at x0,y0
module rrect(w, h, r, x0 = 0, y0 = 0) {
    translate([x0 + r, y0 + r]) offset(r = r) square([w - 2*r, h - 2*r]);
}
module plate_outline(inset = 0) {
    rrect(W_in + 2*ox - 2*inset, H_in + 2*ox - 2*inset, r_out + clr + skirt_t - inset,
          -ox + inset, -ox + inset);
}

// tub, open side up, back wall on z = -back_t..0
module tub() {
    difference() {
        translate([0, 0, -back_t]) linear_extrude(back_t + D_in)
            rrect(W_in + 2*wall, H_in + 2*wall, r_out, -wall, -wall);
        // cavity
        linear_extrude(D_in + eps) rrect(W_in, H_in, r_out - wall);
    }
    // corner bosses, full depth, pilot holes from the top
    for (b = boss_xy)
        translate([b[0] - boss/2, b[1] - boss/2, 0])
            difference() {
                cube([boss, boss, D_in]);
                translate([boss/2, boss/2, D_in - 10]) cylinder(d = boss_pilot_d, h = 11);
            }
    // Pi mounts
    for (h = pi_holes)
        if (pi_mount == "pegs")
            translate([h[0], h[1], 0]) difference() {
                cylinder(d = peg_boss_d, h = peg_boss_h);
                translate([0, 0, -eps]) cylinder(d = peg_cb_d, h = peg_cb_h + eps);
                translate([0, 0, -eps]) cylinder(d = peg_socket_d, h = peg_boss_h + 2*eps);
            }
        else
            translate([h[0], h[1], 0]) difference() {
                cylinder(d = pi_stand_d, h = pi_seat);
                translate([0, 0, -back_t + 0.5]) cylinder(d = pi_screw_d, h = back_t + pi_seat);
            }
    // relay cradle: pad under each corner, L wall outside it
    translate([rx0, ry0, 0]) relay_corner();
    translate([rx1, ry0, 0]) mirror([1, 0, 0]) relay_corner();
    translate([rx0, ry1, 0]) mirror([0, 1, 0]) relay_corner();
    translate([rx1, ry1, 0]) mirror([1, 0, 0]) mirror([0, 1, 0]) relay_corner();
}

module relay_corner() {
    lh = relay_top + 4;
    cube([6, 6, relay_lift]);
    translate([-relay_clr - 1.5, -relay_clr - 1.5, 0]) cube([1.5, 7, lh]);
    translate([-relay_clr - 1.5, -relay_clr - 1.5, 0]) cube([7, 1.5, lh]);
}

// everything cut out of the tub
module tub_cuts() {
    // wall screws through the back
    for (m = mount_xy)
        translate([m[0], m[1], -back_t - eps]) cylinder(d = mount_hole_d, h = back_t + 2*eps);
    // peg bores through the back wall, the air escapes below
    if (pi_mount == "pegs")
        for (h = pi_holes)
            translate([h[0], h[1], -back_t - eps]) cylinder(d = peg_socket_d, h = back_t + 2*eps);
    // power cable slot, closed, the micro USB plug passes
    translate([pwr_x - pwr_slot[0]/2, -wall - eps, plug_z - pwr_slot[1]/2])
        cube([pwr_slot[0], wall + 2*eps, pwr_slot[1]]);
    // gate opener wires
    translate([opener_x, -wall - eps, plug_z]) rotate([-90, 0, 0])
        cylinder(d = opener_hole_d, h = wall + 2*eps);
    // vent slots, left of the mic
    for (i = [0 : vent_n - 1])
        translate([10 + i*(vent_l + 4), -wall - eps, plug_z - vent_w/2])
            cube([vent_l, wall + 2*eps, vent_w]);
}

// backplate, upright: plate on z = D_in..D_in+lid_t, skirt down the outside
module lid() {
    difference() {
        translate([0, 0, D_in - skirt_h]) linear_extrude(skirt_h + lid_t) plate_outline();
        // hollow for the tub walls
        translate([0, 0, D_in - skirt_h - eps]) linear_extrude(skirt_h + eps)
            rrect(W_in + 2*(wall + clr), H_in + 2*(wall + clr), r_out + clr, -wall - clr, -wall - clr);
        // corner screws pass through, the panel has the countersinks
        for (b = boss_xy)
            translate([b[0], b[1], D_in - eps]) cylinder(d = lid_thru_d, h = lid_t + 2*eps);
        // camera window
        translate([cam_x, cam_y, D_in - eps]) cylinder(d = cam_win_d, h = lid_t + 2*eps);
        // name rows: button hole, and a window behind the card pocket
        for (i = [0 : n - 1]) {
            translate([btn_x, row_y(i), D_in - eps]) cylinder(d = btn_hole_d, h = lid_t + 2*eps);
            translate([0, 0, D_in - eps]) linear_extrude(lid_t + 2*eps)
                rrect(label_win[0] - 2, label_win[1] - 2, 1,
                      label_x - label_win[0]/2 + 1, row_y(i) - label_win[1]/2 + 1);
        }
        // opening behind the mic grille
        translate([0, 0, D_in - eps]) linear_extrude(lid_t + 2*eps)
            rrect(mic_slot_l + 4, mic_slot_n*mic_slot_pitch + 4, 2,
                  mic_x - mic_slot_l/2 - 2, mic_y - mic_slot_n*mic_slot_pitch/2 - 2);
    }
    // camera posts, lens through the window
    for (h = cam_holes)
        translate([h[0], h[1], D_in - cam_post_h]) difference() {
            cylinder(d = cam_post_d, h = cam_post_h);
            translate([0, 0, -eps]) cylinder(d = cam_screw_d, h = 6);
        }
    // relay pillars, land on the bare strip along the PCB's long edges
    if (relay_pillars)
        for (x = pillar_xs, s = [0, 1]) {
            y0 = s == 0 ? ry0 - 2 : ry1 - relay_edge;
            translate([x - pillar_w/2, y0, D_in - pillar_h]) cube([pillar_w, 2 + relay_edge, pillar_h]);
        }
}

// panel, upright: back on z = face_z, field face at face_z + face_t,
// bezel, rings, frames, and collars stand bezel_h proud of the field
module face() {
    z0 = face_z;
    zf = face_z + face_t;         // field face
    zb = zf + bezel_h;            // bezel top
    difference() {
        union() {
            // base plate
            translate([0, 0, z0]) linear_extrude(face_t) plate_outline();
            // raised frame, outer edge chamfered
            difference() {
                hull() {
                    translate([0, 0, zf - eps]) linear_extrude(eps) plate_outline();
                    translate([0, 0, zb - eps]) linear_extrude(eps) plate_outline(bezel_ch);
                }
                translate([0, 0, zf - 2*eps]) linear_extrude(bezel_h + 3*eps) field();
            }
            // camera ring and hood
            translate([cam_x, cam_y, zf - eps]) cylinder(d = cam_ring_d, h = bezel_h + eps);
            translate([cam_x, cam_y + cam_ring_d/2 - 1, zf - eps]) hull() {
                translate([-cam_brow[0]/2, 0, 0]) cube([cam_brow[0], cam_brow[1] + 1, eps]);
                translate([-cam_brow[0]/2, 0, bezel_h + cam_brow[2] - 1])
                    cube([cam_brow[0], 1, 1]);
            }
            // name rows: label frame and button collar
            for (i = [0 : n - 1]) {
                translate([0, 0, zf - eps]) linear_extrude(bezel_h + eps)
                    rrect(label_frame[0], label_frame[1], 3,
                          label_x - label_frame[0]/2, row_y(i) - label_frame[1]/2);
                translate([btn_x, row_y(i), zf - eps]) cylinder(d = btn_collar_d, h = bezel_h + eps);
            }
        }
        // corner screws, countersunk in the field
        for (b = boss_xy) {
            translate([b[0], b[1], z0 - eps]) cylinder(d = lid_thru_d, h = face_t + 2*eps);
            translate([b[0], b[1], zf - (lid_cs_d - lid_thru_d)/2])
                cylinder(d1 = lid_thru_d, d2 = lid_cs_d, h = (lid_cs_d - lid_thru_d)/2 + eps);
        }
        // camera eye, chamfered wide at the top of the ring
        translate([cam_x, cam_y, z0 - eps]) cylinder(d = cam_face_d, h = face_t + bezel_h + 2*eps);
        translate([cam_x, cam_y, zb - 2]) cylinder(d1 = cam_face_d, d2 = cam_face_d + 4, h = 2 + eps);
        // module seams
        for (y = seams)
            translate([bezel_w - ox + 3, y - seam_w/2, zf - seam_d])
                cube([W_in + 2*ox - 2*bezel_w - 6, seam_w, seam_d + eps]);
        // blind speaker grooves, room for a speaker one day
        if (spk_grille)
            for (i = [0 : spk_n - 1])
                translate([cam_x - spk_l/2, spk_y + (i - (spk_n - 1)/2)*4 - 0.75, zf - 0.8])
                    cube([spk_l, 1.5, 0.8 + eps]);
        // name rows: window with a chamfer, card pocket in the back, button hole
        for (i = [0 : n - 1]) {
            translate([0, 0, z0 - eps]) linear_extrude(face_t + bezel_h + 2*eps)
                rrect(label_win[0], label_win[1], 1.5,
                      label_x - label_win[0]/2, row_y(i) - label_win[1]/2);
            translate([0, 0, zb - 0.8]) linear_extrude(0.8 + eps)
                rrect(label_win[0] + 1.6, label_win[1] + 1.6, 2.3,
                      label_x - label_win[0]/2 - 0.8, row_y(i) - label_win[1]/2 - 0.8);
            translate([0, 0, z0 - eps]) linear_extrude(label_pocket_d + eps)
                rrect(label_card[0] + 0.5, label_card[1] + 0.5, 1.5,
                      label_x - label_card[0]/2 - 0.25, row_y(i) - label_card[1]/2 - 0.25);
            translate([btn_x, row_y(i), z0 - eps]) cylinder(d = btn_hole_d, h = face_t + bezel_h + 2*eps);
            translate([btn_x, row_y(i), zb - 0.8])
                cylinder(d1 = btn_hole_d, d2 = btn_hole_d + 1.6, h = 0.8 + eps);
        }
        // mic grille, through
        for (i = [0 : mic_slot_n - 1])
            translate([mic_x - mic_slot_l/2, mic_y + (i - (mic_slot_n - 1)/2)*mic_slot_pitch - mic_slot_w/2, z0 - eps])
                cube([mic_slot_l, mic_slot_w, face_t + 2*eps]);
        // brand mark on the bottom bezel
        if (brand != "")
            translate([W_in/2, -ox + bezel_w/2 - 0.2, zb - 0.4]) linear_extrude(0.4 + eps)
                text(brand, size = brand_size, font = brand_font, halign = "center", valign = "center");
    }
}

// the field inside the raised frame
module field() {
    rrect(W_in + 2*ox - 2*bezel_w, H_in + 2*ox - 2*bezel_w, field_r, -ox + bezel_w, -ox + bezel_w);
}

// dummy volumes for the preview: what the box has to clear
module dummies() {
    color("green", 0.6) {
        // Pi board, header, F-F jumper housings
        translate([pi_x0, pi_y0, pi_z]) cube([pi_l, pi_w, pi_pcb_t]);
        translate([pi_x0 + 8.3, pi_y0 + 22.4, pi_z + pi_pcb_t]) cube([48.4, 5.1, 8.5]);
        translate([pi_x0 + 8.3, pi_y0 + 22.4, pi_z + pi_pcb_t + 8.5]) cube([48.4, 5.1, 14]);
        // camera connector and ribbon stub
        translate([pi_x0 + pi_l - 4, pi_y0 + 9, pi_z + pi_pcb_t]) cube([4, 17, 3]);
    }
    color("gray", 0.6) {
        // mic chain, power plug
        translate([mic_x - otg_w/2, pi_y0 - otg_len, plug_z - mic_t/2]) cube([otg_w, otg_len, mic_t]);
        translate([mic_x - mic_w/2, pi_y0 - otg_len - mic_len, plug_z - mic_t/2 + 1.5]) cube([mic_w, mic_len, 5]);
        translate([pwr_x - pwr_plug_w/2, pi_y0 - pwr_plug_l, plug_z - pwr_plug_t/2]) cube([pwr_plug_w, pwr_plug_l, pwr_plug_t]);
        translate([pwr_x, 0, plug_z]) rotate([-90, 0, 0]) cylinder(d = 4, h = pi_y0 - pwr_plug_l);
    }
    color("blue", 0.6) {
        // relay module
        translate([rx0, ry0, relay_lift]) cube([relay_l, relay_w, relay_pcb_t]);
        translate([rx0 + 8, ry0 + 3, relay_top]) cube([relay_l - 16, relay_w - 6, relay_h - relay_top]);
    }
    color("red", 0.6) {
        // camera board, lens
        translate([cam_x - cam_w/2, cam_top - cam_h, D_in - cam_post_h - 1]) cube([cam_w, cam_h, 1]);
        translate([cam_x, cam_y, D_in - cam_post_h]) cylinder(d = 9, h = cam_lens_h);
        // button tails
        for (i = [0 : n - 1])
            translate([btn_x, row_y(i), D_in - btn_tail]) cylinder(d = btn_nut_d, h = btn_tail);
    }
}

if (part == "tub") {
    difference() { tub(); tub_cuts(); }
} else if (part == "lid") {
    // flipped, print ready: front face on the bed
    translate([0, 0, D_in + lid_t]) rotate([180, 0, 0]) lid();
} else if (part == "face") {
    // print ready as is: back on the bed, face up
    translate([0, 0, -face_z]) face();
} else {
    difference() { tub(); tub_cuts(); }
    dummies();
    color("white", 0.35) lid();
    color("silver") face();
    echo(inside = [W_in, H_in, D_in],
         outside = [W_in + 2*ox, H_in + 2*ox, back_t + D_in + lid_t + face_t + bezel_h],
         pi_y0 = pi_y0, relay = [rx0, ry0, rx1, ry1], cam = [cam_x, cam_y], rows = [for (i = [0 : n - 1]) row_y(i)],
         label_x = label_x, mic_y = mic_y, seams = seams, spk_y = spk_y,
         pi_z = pi_z, plug_z = plug_z, cam_post_h = cam_post_h, pillar_h = pillar_h);
}
