//options:

// block
x_len = 165.1; // 6.5" length 
y_len = 101.6; // 4" slot axis
z_len = 63.5; // 2.5" height

// ball-end mills (DOC is radius):
// a) 3/16 (0.1875 : 0.09375)
d_a = 4.7625 ;
r_a = 2.38125;
start_a = 12.7; // 1/2" from edge
echo("3/16 center:", (start_a + r_a), "depth: ", r_a); 
// b) 1/4 (0.25 : 0.125)
d_b = 6.35; 
r_b = 3.175;
start_b = start_a + d_a + (d_a + d_b);
echo("1/4 center:", (start_b + r_b), "depth: ", r_b); 
// c) 5/16 (0.3125 : 0.15625)
d_c = 7.93242; 
r_c = 3.96875;
start_c = start_b + d_b + (d_b + d_c);
echo("5/16 center:", (start_c + r_c), "depth: ", r_c); 
// d) 3/8 (0.375 : 0.1875)
d_d = 9.525;
r_d = 4.7625;
start_d = start_c + d_c + (d_c + d_d);
echo("3/8 center:", (start_d + r_d), "depth: ", r_d); 
// e) 1/2  (0.5 : 0.25)
d_e = 12.7; 
r_e = 6.35;
start_e = start_d + d_d + (d_d + d_e);
echo("1/2 center:", (start_e + r_e), "depth: ", r_e); 
//start_e = x_len - 12.7;
//z_e = z_len - r_e;
// f) 1/4" v slot
d_v = 6.35;
hyp_v = sqrt((d_v * d_v) + (d_v * d_v));
depth_v = (sin(45) * d_v);
start_v = x_len - (12.7*2) - (0.5 * hyp_v);
echo("1/4 V slot center:", (start_v + (hyp_v * 0.5)), "depth: ", depth_v); 
// shoulder depth: 1/8"
s_depth = 3.175;
echo("Shoulder: depth 1/8 Height: 1/2");
// through-hole: 1/4 oughta do it
h_d = 6.35;
h_y = y_len - (12.7); // 1/2" from end
echo("Thru-hole position", h_y);
// clamp-holes: 10/32 0.1590" tap drill
t_d = 4.0386;
t_r = 4.0386 * 0.5;
echo("Clamp hole 0.1590 drill 10-32 tap Position:", (y_len * 0.5));

module groove(start_x, rad) {
    translate([start_x, 0.01, z_len])
        rotate([-90, 0, 0])
            cylinder(y_len + 0.02, r=rad);
    // thru-hole
    translate([start_x, h_y, - 0.1])
        cylinder(z_len + 0.2, d=h_d);
}

module v_slot(start_x, side) {
    translate([start_x, 0 - 0.01, z_len])
        rotate([0, 45, 0])
            cube([side, y_len + 0.02, side]);
    // thru-hole
    translate([start_x + (hyp_v * 0.5), h_y, - 0.1])
        cylinder(z_len + 0.2, d=h_d);
}

module clamp_hole(start, end) {
    
    loc = ((end - start) * 0.5) - t_r;
    depth = z_len / 4;
    echo("CLAMP HOLE", (start + loc));
    translate([start + loc, ((y_len * 0.5) - t_r), z_len - depth])
        cylinder(depth + 0.1, d=t_d);
}

difference() {
    // tooling plate:
    cube([x_len, y_len, z_len]);
    // slots:
    //  3/16
    groove(start_a, r_a);
    // 1/4
    groove(start_b, r_b);
    // 5/15
    groove(start_c, r_c); 
    // 3/8
    groove(start_d, r_d);
     // 1/2
    groove(start_e, r_e);

    v_slot(start_v, d_v);
    
    // shoulders
    translate([-0.1, -0.1, 0])
        cube([x_len + 0.2, s_depth + 0.1, 12.7]);
    translate([-0.1, y_len - s_depth + 0.1, 0])
        cube([x_len + 0.2, s_depth + 0.1, 12.7]);
        
    // clamp holes
    //clamp_hole(0, start_a);
    clamp_hole(start_a, start_b);
    //clamp_hole(start_b, start_c);
    clamp_hole(start_c, start_d);
    //clamp_hole(start_d, start_e);
    clamp_hole(start_e, start_v);
        
};