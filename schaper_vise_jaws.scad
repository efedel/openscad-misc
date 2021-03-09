
v_x = 152.4; // 6"
v_y = 25.4; // 1"
v_z = 38.1; // 1.5"
hole_dia = 5.1054; // 0.2010"
hhd = hole_dia / 2;
hole_a_x = 34.417; //1.355
hole_a_z = 10.414; //0.41
hole_b_x = v_x - hole_a_x;
hole_b_z = hole_a_z;
jaw_depth = 4.7625; // 3/16" or 0.1875

cutout_x = 101.6; // 4"
cutout_y = v_y - jaw_depth;
cutout_z = 25.4; // 1"

module bolt_hole(x, y, z, dia) {
    translate([x, -0.001, z])
        rotate([-90, 0, 0])
            cylinder(h=(y + 0.002), r=dia, $fn=99);
}

difference() {
    // vise jaw 
    cube([v_x, v_y, v_z]);
    bolt_hole(hole_a_x, v_y, hole_a_z, hole_dia);
    bolt_hole(hole_b_x, v_y, hole_b_z, hole_dia);
    translate([((v_x - cutout_x) / 2), jaw_depth, 0])
        cube([cutout_x, cutout_y, cutout_z]);

};

