module basic_toolbit(h, v, length){
    cube([h, length, v]);
}

// front clearance, side rake
module front_face(h, v, clr, rake) {

    tan_clr = tan(clr);
    y_off_clr = tan_clr * v;
    z_off_clr = tan_clr * y_off_clr;
    
    tan_rake = tan(rake);
    y_off_rake = tan_rake * h;
    z_off_rake = tan_rake * y_off_rake;
        
    // NOTE: this is a side effect
    //       used by side_face()
    far_x = y_off_rake;
    
    new_y = -(y_off_clr + y_off_rake - v);
    new_z = v + z_off_rake + z_off_clr;
    
    translate([-2, new_y, new_z]) {

        rotate([clr, 0, rake]) {
            // padding: to account for rotation
            cube([h + 2, v * 2, v * 2]);
        };
    };
}

// clr = vertical clearance, if applicable
module side_face(h, v, rake, clr) {
    rotate([0, clr, 360 - rake]) {
        // padding: to account for rotation
        cube([h, v * 2, v * 2]);
    };
}

module back_rake(a) {
}

// see calc_face_coords for unrolling
function calc_face_near_y(h, v, clr, rake, face_len) =  (tan(clr) * (v + (tan(rake) * (sin(rake) * face_len)) + (tan(clr) * (tan(clr) * v))) - -((tan(clr) * v) + (sin(rake) * face_len) - v));
function calc_face_far_y(rake, face_len) =  (tan(rake) * face_len);

function calc_face_far_x(rake, face_len) = (cos(rake) * face_len);

module calc_face_coords(h, v, clr, rake, face_len) {
    //h = 9.525; // horizontal 3/8"
    //v = 9.525; // vertical 3/8"
    //clr = 30; //210;
    //rake = 10;
    //face_len = h - (h / 5);
    y_off_clr = tan(clr) * v;
    z_off_clr = tan(clr) * y_off_clr;
    y_off_rake = sin(rake) * face_len;
    z_off_rake = tan(rake) * y_off_rake;
    new_y = -(y_off_clr + y_off_rake - v);
    new_z = v + z_off_rake + z_off_clr;
    near_y = (tan(clr) * new_z) - new_y; 
    far_y = tan(rake) * face_len;
    // NOTE: 0.5 is from front_face()   
    //[ [-0.5, 
    //    near_y],
    //  [-0.5 + (cos(rake) * face_len), 
    //   near_y + far_y]
    //]
}

difference(){
    // cross section of toolbit in mm
    sz_h = 9.525; // horizontal 3/8"
    sz_v = 9.525; // vertical 3/8"
    sz_len = 101.6; // length of toobit *\(4")
    f_clr = 210; // 180 + 30
    f_rake = 350;
    s_clr = 0;
    s_rake = 20;
    face_len = sz_h - (sz_h / 5);

    basic_toolbit(sz_h, sz_v, sz_len);
    front_face(sz_h, sz_v, f_clr, f_rake);
    
    //far_x = (tan(f_rake) * sz_h) + (tan(f_clr) * sz_v);
    //[ [-0.5, 
    //    near_y],
    //  [-0.5 + (cos(rake) * face_len), 
    //   near_y + far_y]
    near_y = calc_face_near_y(sz_h, sz_v, f_clr, f_rake, face_len);
    far_y = calc_face_far_y(f_rake, face_len);
    near_x = -2; //0.5;
    far_x = calc_face_far_x(f_rake, face_len);

    translate([near_x + far_x, near_y + far_y, 0]) {
        side_face(sz_h, sz_v, s_rake, s_clr);
    };
    
    // TOP SHAPE 
    ht_top = 1.0;
    
    translate([0,0,(sz_v - ht_top + 0.1)]) {
        // NOTE: changing one of the sz_x
        //       will add a facet (angle)
        //cylinder(ht_top,sz_h,sz_v,$fn=3);
    }; 
};

    h = 9.525; // horizontal 3/8"
    v = 9.525; // vertical 3/8"
    clr = 30; //210;
    rake = 10; // 350
    s_clr = 5;
    s_rake = 340;
    face_len = h - (h / 5);
    b_rake = 265;

    //y_off_clr = tan(clr) * v;
    //z_off_clr = tan(clr) * y_off_clr;
    //y_off_rake = sin(rake) * face_len;
    //z_off_rake = tan(rake) * y_off_rake;
    //new_y = -(y_off_clr + y_off_rake - v);
    //new_z = v + z_off_rake + z_off_clr;
    //near_x = -2;
    //far_x = -2 + (cos(rake) * face_len);
    //near_y = (tan(clr) * new_z) - new_y; 
    //far_y = tan(rake) * face_len;
    near_y = calc_face_near_y(h, v, clr, rake, face_len);
    far_y = calc_face_far_y(rake, face_len);
    near_x = -2; //0.5;
    far_x = calc_face_far_x(rake, face_len);
    //cube([h, near_y, v]);

    adj = h - face_len;
    //hyp = adj / cos(s_rake);
    opp = tan(s_rake) * adj;
    echo(NEAR_X=near_x,FAR_X=far_x,NEAR_Y=near_y,FAR_Y=far_y,OPP=opp);
    inner_x = h; //near_x + h;
    // BROKE:
    inner_y = near_y + far_y + (-opp);
    

    translate([inner_x, inner_y, v]) {
        //rotate([0, b_rake, s_rake]) {
            // padding: to account for rotation
            cube([h/2,v*2, v]);
        //};
    };

    