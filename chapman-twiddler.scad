// NOTE: printed at 6.89 to 6.95
hex_dia = 7.30;
cyl_len = 10;
cyl_dia = 25;
handle_dia = 6;
handle_len = 15;

union() {
    difference() {
        cylinder(d=cyl_dia, h=cyl_len, $fn=270);
        cylinder(d=hex_dia, h =cyl_len, $fn=6);
    }
    translate([(cyl_dia/2), 0, ((cyl_len /2) )]) {
        rotate([0, 90, 0])
            cylinder(d=handle_dia, h=handle_len, $fn=5);
    }
    translate([-(cyl_dia/2) - handle_len, 0, ((cyl_len /2) )]) {
        rotate([0, 90, 0])
            cylinder(d=handle_dia, h=handle_len, $fn=5);
    }
}
