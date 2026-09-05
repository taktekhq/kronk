// Gate box for the Raspberry Pi Zero 2 W, v1. One name, one button.
//
// Two parts: the tub and the faceplate. The tub screws to the wall and
// carries the Pi, the relay, the mic chain, and the cable exits at the
// bottom. The faceplate carries the camera, the name rows, and the
// buttons, and caps the tub with an outer skirt so rain runs past the
// seam. Four M3 screws from the front into the corner bosses.
//
// Names: one row per entry in `names`, top to bottom, name engraved on
// the left, button on the right. Add a name, the box grows a row. Every
// extra button needs its own GPIO pin and its own two jumpers.
//
// Inside, from the top: relay on the back wall with the camera on the
// faceplate in front of it, the Pi with its header toward the
// faceplate so the F-F jumpers plug straight in, then the USB mic on
// its OTG adapter and the power plug hanging off the Pi's bottom edge
// to the exits in the bottom wall. The button tails and the name rows
// sit beside the mic chain, over a clear stretch of back wall.
//
// The Pi mounts on the pi5-saddle rivet pegs, same bore and counterbore
// as the saddle, or on M2.5 screws with pi_mount = "screws". The relay
// sits in a corner cradle and is boxed in by four pillars from the
// faceplate, nothing clips it. The camera screws to four posts on the
// faceplate with M2 screws, lens flush in the window.
//
// Three outputs from this one file:
//   openscad -o gate-box-tub.stl gate-box.scad                  (upright, open side up)
//   openscad -D 'part="lid"' -o gate-box-lid.stl gate-box.scad  (flipped, face on the bed)
//   part="assembly" previews everything with dummy volumes for the parts.
//
// MEASURE before printing, all in mm. Guesses are marked here and read
// off the real parts once: relay_l, relay_w, relay_h, relay_edge;
// otg_len and mic_len as a plugged-in chain; cam_lens_h and
// cam_lens_from_top on the Camera Module 3; btn_tail with jumpers on.
//
// Print: tub as the STL opens, no supports. Faceplate as the STL
// opens, face down, no supports. 0.2mm, PLA, dry the spool.

part = "tub";   // "tub" | "lid" | "assembly"

names = ["KRONK"];  // one row per name, top to bottom. Set the real name.
row_pitch = 26;     // row to row
name_size = 7;      // letter height
name_depth = 0.8;   // engraving depth into the front face
name_font = "Liberation Sans:style=Bold";

// shell
wall = 2.5;         // side walls
back_t = 2.5;       // back wall
lid_t = 2.5;        // faceplate
D_in = 36;          // inside depth, back wall to faceplate
clr = 0.3;          // faceplate skirt over the tub walls
skirt_t = 2;        // skirt thickness
skirt_h = 6;        // how far the skirt reaches down over the walls
boss = 7;           // corner boss, square
boss_pilot_d = 2.6; // M3 self tapping into the boss
lid_thru_d = 3.4;   // M3 clearance through the faceplate
lid_cs_d = 6.5;     // countersink for the M3 head
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
grille_d = 2;             // mic grille holes

eps = 0.01;
$fn = 48;

// derived
n = len(names);
chain_len = otg_len + mic_len + chain_gap;
pi_y0 = max(chain_len, 36 + row_pitch*(n - 1));   // rows need room below
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

// tub, open side up, back wall on z = -back_t..0
module tub() {
    difference() {
        union() {
            translate([-wall, -wall, -back_t])
                cube([W_in + 2*wall, H_in + 2*wall, back_t + D_in]);
        }
        // cavity
        translate([0, 0, 0]) cube([W_in, H_in, D_in + eps]);
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
    // mic grille under the mic tip
    for (i = [-1, 0, 1], j = [-1, 1])
        translate([mic_x + i*3.5, -wall - eps, plug_z + j*2.5]) rotate([-90, 0, 0])
            cylinder(d = grille_d, h = wall + 2*eps, $fn = 16);
    // vent slots, left of the mic
    for (i = [0 : vent_n - 1])
        translate([10 + i*(vent_l + 4), -wall - eps, plug_z - vent_w/2])
            cube([vent_l, wall + 2*eps, vent_w]);
}

// faceplate, upright: plate on z = D_in..D_in+lid_t, skirt down the outside
module lid() {
    ox = wall + clr + skirt_t;
    difference() {
        union() {
            translate([-ox, -ox, D_in - skirt_h])
                cube([W_in + 2*ox, H_in + 2*ox, skirt_h + lid_t]);
        }
        // hollow for the tub walls
        translate([-wall - clr, -wall - clr, D_in - skirt_h - eps])
            cube([W_in + 2*(wall + clr), H_in + 2*(wall + clr), skirt_h + eps]);
        // corner screws, countersunk
        for (b = boss_xy) {
            translate([b[0], b[1], D_in - eps]) cylinder(d = lid_thru_d, h = lid_t + 2*eps);
            translate([b[0], b[1], D_in + lid_t - (lid_cs_d - lid_thru_d)/2])
                cylinder(d1 = lid_thru_d, d2 = lid_cs_d, h = (lid_cs_d - lid_thru_d)/2 + eps);
        }
        // camera window, chamfered outside
        translate([cam_x, cam_y, D_in - eps]) cylinder(d = cam_win_d, h = lid_t + 2*eps);
        translate([cam_x, cam_y, D_in + lid_t - 0.8])
            cylinder(d1 = cam_win_d, d2 = cam_win_d + 1.6, h = 0.8 + eps);
        // name rows: button hole right, name engraved left
        for (i = [0 : n - 1]) {
            translate([btn_x, row_y(i), D_in - eps]) cylinder(d = btn_hole_d, h = lid_t + 2*eps);
            translate([8, row_y(i), D_in + lid_t - name_depth])
                linear_extrude(name_depth + eps)
                    text(names[i], size = name_size, font = name_font, valign = "center");
        }
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
} else {
    difference() { tub(); tub_cuts(); }
    dummies();
    color("white", 0.35) lid();
    echo(inside = [W_in, H_in, D_in], outside = [W_in + 2*wall, H_in + 2*wall, back_t + D_in + lid_t],
         pi_y0 = pi_y0, relay = [rx0, ry0, rx1, ry1], cam = [cam_x, cam_y], rows = [for (i = [0 : n - 1]) row_y(i)],
         pi_z = pi_z, plug_z = plug_z, cam_post_h = cam_post_h, pillar_h = pillar_h);
}
