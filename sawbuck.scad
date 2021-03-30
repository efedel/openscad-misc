// 1:12 scale
sf = 12.0 ; // scale factor 1:12
// nominal 2x4 : 1.5 x 3.5
w2x4 = 88.9/ sf; // 3.5" in mm
h2x4 = 38.1 / sf; // 1.5" in mm
span = 1016.0 / sf; // 40" 
log_len = 406.4 / sf; //16"

module rotate_about_pt(rot, pt) {
    translate(pt)
        rotate(rot)
            translate(-pt)
                children();   
}

// cross bars
// position (Y axis)
// board width, height, length
module x_frame(pos, bw, bh, bl, x_off, z_off) {
    
    translate([x_off,pos,0]) {
        rotate([0, -45, 0])
            cube([bw, bh, bl]);
        
        translate([-(2*x_off), bh, z_off])
            rotate([0,45,0])
                cube([bw, bh, bl]);
    };
}

// location of 1/2 hypotenuse on base
x_off = (cos(45) * (0.5 * span));


w_45_hyp = w2x4;
w_45_side = (cos(45) * w2x4);
w_45_height = (cos(45) *w_45_side);

// compensate for openscad's choice of rotation point
z_off =w_45_side;

union() {
    x_frame(0, w2x4, h2x4, span, x_off, z_off);
    x_frame((2*h2x4) + span, w2x4, h2x4, span, x_off, z_off);
    x_frame((4*h2x4) + (2*span), w2x4, h2x4, span, x_off, z_off);
    full_len = (6*h2x4) + (2*span);
    
    translate([-x_off, 0, z_off]) {
        translate([0.5*h2x4, 0, 0.5*w2x4])
        rotate([0, 45, 0])
        translate([-0.5*h2x4, 0, -0.5*w2x4])
        cube([h2x4, full_len, w2x4]); 
    };

    translate([x_off, 0, z_off]) {
        //translate([0.5*h2x4, 0, 0.5*w2x4])
        //rotate([0, -45, 0])
        //translate([-0.5*h2x4, 0, -0.5*w2x4])
        cube([h2x4, full_len, w2x4]); 
    };
};