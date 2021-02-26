$side_rake = 10;
$side_cutting_edge = 20;
$side_relief = 10;
$end_cutting_edge = 10;
$end_relief = 30;
$back_rake = 5;
// cross section of toolbit blank in mm
$blank_h = 9.525; // horizontal 3/8"
$blank_v = 9.525; // vertical 3/8"
$blank_len = 101.6; // length of toobit *\(4")
    
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

module back_rake(h, v, b_rake, f_clr, f_rake, s_rake, s_edge, face_len) {
    s_edge_comp = 360 - s_edge;

    near_y = calc_face_near_y(h, v, f_clr, f_rake, face_len);
    far_y = calc_face_far_y(f_rake, face_len);
    near_x = -2;
    far_x = calc_face_far_x(f_rake, face_len);

    // TOP SHAPE 
    adj = h - face_len;
    opp = tan(s_edge) * adj;
    //echo(NEAR_X=near_x,FAR_X=far_x,NEAR_Y=near_y,FAR_Y=far_y,OPP=opp);
    inner_x = far_x; //h; //near_x + h;
    inner_y = near_y + far_y ; //+ (-opp);

    translate([inner_x, inner_y, v]) {
        rotate([0, s_rake, s_edge_comp]) {
            translate([0, -10, 0]) {
                // padding: to account for rotation
                cube([h,v*2, v * 2]);
            };
        };
    };

}

// see calc_face_coords for unrolling
function calc_face_near_y(h, v, clr, rake, face_len) =  (tan(clr) * (v + (tan(rake) * (sin(rake) * face_len)) + (tan(clr) * (tan(clr) * v))) - -((tan(clr) * v) + (sin(rake) * face_len) - v));
function calc_face_far_y(rake, face_len) =  (tan(rake) * face_len);

function calc_face_far_x(rake, face_len) = (cos(rake) * face_len);

module calc_face_coords(h, v, clr, rake, face_len) {
    y_off_clr = tan(clr) * v;
    z_off_clr = tan(clr) * y_off_clr;
    y_off_rake = sin(rake) * face_len;
    z_off_rake = tan(rake) * y_off_rake;
    new_y = -(y_off_clr + y_off_rake - v);
    new_z = v + z_off_rake + z_off_clr;
    near_y = (tan(clr) * new_z) - new_y; 
    far_y = tan(rake) * face_len;
    // NOTE: 0.5 is from front_face()   
    rv = [ [-0.5, 
        near_y],
      [-0.5 + (cos(rake) * face_len), 
       near_y + far_y]
    ];
}

difference(){
    // cross section of toolbit in mm
    sz_h = $blank_h;
    sz_v = $blank_v;
    sz_len = $blank_len;
    f_clr = 180 + $end_relief;
    f_rake = 360 - $end_cutting_edge;
    s_clr = $side_relief;
    s_edge = $side_cutting_edge;
    s_edge_comp = 360 - $side_cutting_edge;
    s_rake = 270 - $side_rake;
    b_rake = $back_rake;
    face_len = sz_h - (sz_h / 5);

    basic_toolbit(sz_h, sz_v, sz_len);
    front_face(sz_h, sz_v, f_clr, f_rake);
    
    near_y = calc_face_near_y(sz_h, sz_v, f_clr, f_rake, face_len);
    far_y = calc_face_far_y(f_rake, face_len);
    near_x = -2; //0.5;
    far_x = calc_face_far_x(f_rake, face_len);
    
    //cube([h*2, near_y, v*2]);

    translate([near_x + far_x, near_y + far_y, 0]) {
        side_face(sz_h, sz_v, s_edge, s_clr);
    };
    
    back_rake(sz_h, sz_v, b_rake, f_clr, f_rake, s_rake, s_edge, face_len);  
};

    h = 9.525; // horizontal 3/8"
    v = 9.525; // vertical 3/8"
    clr = 30; //210;
    rake = 10; // 350
    s_clr = 5;
    s_edge = 340;
    face_len = h - (h / 5);
    s_rake = 265;

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
    //hyp = adj / cos(s_edge);
    opp = tan(s_edge) * adj;
    echo(NEAR_X=near_x,FAR_X=far_x,NEAR_Y=near_y,FAR_Y=far_y,OPP=opp);
    inner_x = far_x; //h; //near_x + h;
    // BROKE:
    inner_y = near_y + far_y ; //+ (-opp);
    

    translate([inner_x, inner_y, v]) {
        rotate([0, s_rake, s_edge]) {
            translate([0, -10, 0]) {
                // padding: to account for rotation
                //cube([h/2,v*2, v]);
            };
        };
    };

    