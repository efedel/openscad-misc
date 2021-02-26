// toolbit width in mm (default: 9.5 [3/8"])
$blank_h = 9.525; // [6.35:15.875]
// toolbit height in mm (default: 9.5 [3/8"])
$blank_v = 9.525; // [6.35:15.875]
// toolbit length in mm (default: 100 [4"])
$blank_len = 101.6; // [25:200]

// tool angles - see tool-angle-nomeclature.png

$side_rake = 10; //[0:35]
$side_cutting_edge = 20; // [0:35]
$side_relief = 0; //[0:20]
$end_cutting_edge = 10; //[0:45]
$end_relief = 30; // [0:20]
$back_rake = 5; // [-35:35]
$nose_radius = 0; // [0]

$face_len = $blank_h - ($blank_h / 5); // [0:15.875]
    
// Construct a basic rectangular toolbit
module basic_toolbit(h, v, length){
    cube([h, length, v]);
}
// Apply end-relief (front clearance) and
// end-cutting-edge (front rake)
module front_face(h, v, clr, rake) {
    tan_clr = tan(clr);
    y_off_clr = tan_clr * v;
    z_off_clr = tan_clr * y_off_clr;
    
    tan_rake = tan(rake);
    y_off_rake = tan_rake * h;
    z_off_rake = tan_rake * y_off_rake;
            
    new_y = -(y_off_clr + y_off_rake - v);
    new_z = v + z_off_rake + z_off_clr;
    
    translate([-2, new_y, new_z]) {

        rotate([clr, 0, rake]) {
            // padding: to account for rotation
            cube([h + 2, v * 2, v * 2]);
        };
    };
}

module side_cutting_edge_and_relief(near_x, near_y, far_x, far_y, h, v, rake, clr) {
    rake_comp = 360 - rake;
    
    translate([near_x + far_x, near_y + far_y, 0]) {
        //side_face(sz_h, sz_v, s_edge_comp, s_clr);
        rotate([0, clr, rake_comp]) {
        // padding: to account for rotation
            cube([h, v * 2, v * 2]);
        };
    };

}

// apply side-cutting-edge and side-relief
module side_face(h, v, rake, clr, f_clr, f_rake, face_len) {
    near_y = calc_face_near_y(h, v, f_clr, f_rake, face_len);
    far_y = calc_face_far_y(f_rake, face_len);
    near_x = -2;
    far_x = calc_face_far_x(f_rake, face_len);
    side_cutting_edge_and_relief(near_x, near_y, far_x, far_y, h, v, rake, clr);
}

// Apply back and side rake. 
// This uses values from calc_face_* .
module back_and_side_rake(near_x, near_y, far_x, far_y, h, v, b_rake, s_rake, s_edge) {
    s_edge_comp = 360 - s_edge;
    
    //adj = h - face_len;
    //opp = tan(s_edge) * adj;
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

// apply back rake and side rake
module top_face(h, v, b_rake, f_clr, f_rake, s_rake, s_edge, face_len) {

    near_y = calc_face_near_y(h, v, f_clr, f_rake, face_len);
    far_y = calc_face_far_y(f_rake, face_len);
    near_x = -2;
    far_x = calc_face_far_x(f_rake, face_len);

    back_and_side_rake(near_x, near_y, far_x, far_y, h, v, b_rake, s_rake, s_edge);
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

// Calls the above modules and functions to generate
// a lathe toolbit based on 
module standard_lathe_toolbit() {
    difference(){
        // cross section of toolbit in mm
        sz_h = $blank_h;
        sz_v = $blank_v;
        sz_len = $blank_len;
        f_clr = 180 + $end_relief;
        f_rake = 360 - $end_cutting_edge;
        s_clr = $side_relief;
        s_edge = $side_cutting_edge;
        s_rake = 270 - $side_rake;
        b_rake = $back_rake;
        face_len = sz_h - (sz_h / 5);

        basic_toolbit(sz_h, sz_v, sz_len);
        front_face(sz_h, sz_v, f_clr, f_rake);
    
        near_y = calc_face_near_y(sz_h, sz_v, f_clr, f_rake, face_len);
        far_y = calc_face_far_y(f_rake, face_len);
        near_x = -2; //0.5;
        far_x = calc_face_far_x(f_rake, face_len);
  
    
        //equivalent to:
        //translate([near_x + far_x, near_y + far_y, 0]) {
        //    side_face(sz_h, sz_v, s_edge, s_clr, f_clr,   f_rake, face_len);
        //};
        side_cutting_edge_and_relief(near_x, near_y, far_x, far_y, sz_h, sz_v, s_edge, s_clr);
    
        // equivalent to:
        // top_face(sz_h, sz_v, b_rake, f_clr, f_rake, s_rake, s_edge_comp, face_len);
        back_and_side_rake(near_x, near_y, far_x, far_y, sz_h, sz_v, b_rake, s_rake, s_edge);
    
        // clean up end of tool:
        //cube([h*2, near_y, v*2]);
    };
}

// main():
standard_lathe_toolbit();

// TESTBED
//opp = tan($side_cutting_edge) * ($blank_h - $face_len);
inner_x = calc_face_far_x($end_cutting_edge, $face_len); 
inner_y = calc_face_near_y($blank_h, $blank_v, $end_relief, $end_cutting_edge, $face_len) + calc_face_far_y($end_cutting_edge, $face_len); ;     
translate([inner_x, inner_y, $blank_v]) {
    rotate([0, $side_rake, $side_cutting_edge]) {
        // padding: to account for rotation
        //cube([$blank_h/2,$blank_v*2, $blank_v]);
    };
};

    