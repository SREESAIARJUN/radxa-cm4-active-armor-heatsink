// Radxa CM4 Active Armor Enclosure & Heatsink
// Precision CNC Milled 6061-T6 Aluminum Case
// Outer boundary: 59.0 x 44.0 x 14.0 mm (snug fit for 55.0 x 40.0 mm carrier)

$fn = 60;
board_w = 55.0;
board_h = 40.0;
wall_t = 2.0;
case_w = board_w + 2*wall_t;
case_h = board_h + 2*wall_t;
case_z = 14.0;

module case_base() {
    difference() {
        cube([case_w, case_h, case_z]);
        translate([wall_t, wall_t, 2.0])
            cube([board_w, board_h, case_z]);
        for (x = [wall_t + 2.25, wall_t + 52.75]) {
            for (y = [wall_t + 2.25, wall_t + 37.75]) {
                translate([x, y, -1])
                    cylinder(d=2.8, h=case_z+2);
            }
        }
        translate([wall_t + 8.0, -1, 3.0])
            cube([9.5, wall_t + 2, 4.0]); // USB-C
        translate([wall_t + 35.0, -1, 3.0])
            cube([8.0, wall_t + 2, 4.0]); // HDMI
        translate([case_w - wall_t - 1, wall_t + 13.0, 3.0])
            cube([wall_t + 2, 16.0, 11.0]); // RJ45
    }
    // Thermal cooling pillars for SoC (RK3566/RK3588)
    translate([case_w/2 - 7.5, case_h/2 - 7.5, 2.0])
        cube([15.0, 15.0, 4.5]);
}

case_base();
