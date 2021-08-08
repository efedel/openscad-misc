cap_dia = 16.55;
shoulder_dia = 15.88;
shoulder_depth = 1.82;
root_dia = 14.52;
crest_dia = 12.40; // 2 * 2.07
cap_len = 10;
cap_top=5.30;
hole_dia = 2.34;
slot_depth = 1.59;
slot_width = 1.66;
base_dia = 9.25;
base_depth = 0.8 ; //5.58 - 4.78

difference() {
    cylinder(r=(cap_dia / 2), h=cap_len, $fn=99);
    cylinder(r=(crest_dia / 2), h=(cap_len-cap_top), $fn=99);
    cylinder(r=(hole_dia / 2), h=(cap_len+ 1), $fn=33);
    cylinder(r=(base_dia / 2), h=(cap_len-cap_top+base_depth), $fn=99);
    translate([-(slot_width/2), -(cap_dia / 2) - 0.5, cap_len-slot_depth]) {
        cube([slot_width, cap_dia + 1, slot_depth]);
    } 
    rotate_extrude($fn=99) {
        translate([(shoulder_dia/2), 0, 0])
            square(shoulder_depth);
    }
}
