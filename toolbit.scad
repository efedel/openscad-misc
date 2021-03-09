// toolbit width in mm (default: 9.5 [3/8"])
$blank_h = 9.525; // [6.35:15.875]
// toolbit height in mm (default: 9.5 [3/8"])
$blank_v = 9.525; // [6.35:15.875]
// toolbit length in mm (default: 100 [4"])
$blank_len = 101.6; // [25:200]

// tool angles - see tool-angle-nomeclature.png


$side_rake = 20; //[0:35]
$side_cutting_edge = 20; // [0:35]
$side_relief = 15; //[0:20]
$end_cutting_edge = 10; //[0:45]
$end_relief = 15;// [0:40]
$back_rake = 5; //5; // [-35:35]
$nose_radius = 0; // [0]

$face_len = $blank_h - ($blank_h / 5); // [0:15.875]

// see calc_face_coords for unrolling
function calc_face_near_y(h, v, clr, rake, face_len) =  (abs(tan(clr)) * (v + (abs(tan(rake)) * (abs(sin(rake)) * face_len)) + (abs(tan(clr)) * (abs(tan(clr)) * v))) - ((abs(tan(clr)) * v) + (abs(sin(rake)) * face_len) - v));
function calc_face_far_y(rake, face_len) =  (abs(tan(rake)) * face_len);

function calc_face_far_x(rake, face_len) = (abs(cos(rake)) * face_len);

module calc_face_coords(h, v, clr, rake, face_len) {
    y_off_clr = abs(tan(clr)) * v;
    z_off_clr = abs(tan(clr)) * y_off_clr;
    y_off_rake = abs(sin(rake)) * face_len;
    z_off_rake = abs(tan(rake)) * y_off_rake;
    new_y = y_off_clr + y_off_rake - v;
    new_z = v + z_off_rake + z_off_clr;
    near_y = (abs(tan(clr)) * new_z) - new_y; 
    far_y = (tan(rake)) * face_len;
    // NOTE: 0.5 is from front_face()   
    rv = [ [-0.5, 
        near_y],
      [-0.5 + (abs(cos(rake)) * face_len), 
       near_y + far_y]
    ];
}

function calc_face_y_offset(h, v, clr, rake) = ((abs(tan(clr)) * v) + (abs(tan(rake)) * h) - v);

function calc_face_z_offset(h, v, clr, rake) = (v + (abs(tan(rake)) * (abs(tan(rake)) * h)) + (abs(tan(clr)) * (abs(tan(clr)) * v)));
    
// Construct a basic rectangular toolbit
module basic_toolbit(h, v, length){
    cube([h, length, v]);
}

// Apply end-relief (front clearance) and
// end-cutting-edge (front rake)
module front_face(h, v, clr, rake) {
    /* DEBUG:
    tan_clr = abs(tan(clr));
    y_off_clr = tan_clr * v;
    z_off_clr = tan_clr * y_off_clr;
    
    tan_rake = abs(tan(rake));
    y_off_rake = tan_rake * h;
    z_off_rake = tan_rake * y_off_rake;
    new_y = -(y_off_clr + y_off_rake - v);
    new_z = v + z_off_rake + z_off_clr;
    */
    
    new_y = -calc_face_y_offset(h, v, clr, rake);
    new_z = calc_face_z_offset(h, v, clr, rake);
    
    translate([-2, new_y, new_z]) {

        rotate([clr, 0, rake]) {
            // padding: to account for rotation
            cube([h * 2, v * 2, v * 2]);
        };
    };
}

module side_cutting_edge_and_relief(near_x, near_y, far_x, far_y, h, v, rake, clr) {
    rake_comp = 360 - rake;
    
    // FIXME: near_x should be 0 not -2
    echo(SIDE_X=(near_x + far_x), SIDE_Y=(near_y + far_y));
    translate([near_x + far_x, min(near_y, far_y), 0]) {
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
    
    ang = f_rake; // WRONG
    inner_x = ((h - far_x) / abs(tan(ang)));
    //inner_x = far_x; //h; //near_x + h;
    inner_y = min(near_y, far_y) ; //+ (-opp);
    outer_y = max(near_y, far_y) ; 


    // back rake
    translate([0, inner_y, v]) {
        rotate([-b_rake, 0, 0]) cube([h, outer_y, v]);
    }
    
    // side rake
    translate([inner_x, inner_y, v]) {
        rotate([0, s_rake, s_edge_comp]) {
            // X changes with side rake: greater for smaller angle
            translate([-0.25, 0 - 0.25, 0]) {
                cube([v, max(near_y, far_y) + 0.25, h * 2]);
            };
        };
    };
}

// apply back rake and side rake
module top_face(h, v, b_rake, f_clr, f_rake, s_rake, s_edge, face_len) {

    near_y = calc_face_near_y(h, v, f_clr, f_rake, face_len);
    far_y = calc_face_far_y(f_rake, face_len);
    near_x = 0;
    far_x = calc_face_far_x(f_rake, face_len);

    back_and_side_rake(near_x, near_y, far_x, far_y, h, v, b_rake, s_rake, s_edge);
    
    // FIXME: cube to clear top face
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
        face_len = min($face_len, sz_h); // sz_h - (sz_h / 5);
        
        basic_toolbit(sz_h, sz_v, sz_len);
    
        near_x = -2.0; // FIXME
        near_y = calc_face_near_y(sz_h, sz_v, f_clr, f_rake, face_len);
        far_y = calc_face_far_y(f_rake, face_len);
        far_x = calc_face_far_x(f_rake, face_len);

        /* // DEBUG
        // near_y = (tan(clr) * new_z) - new_y; 
        echo(Y_CLR_15=(tan(15) * sz_v), Y_RAKE_15=(sin(f_rake) * face_len));
        echo(Y_OFF_15=((tan(15) * sz_v) + (sin(f_rake) * face_len) - sz_v));
        echo(Y_CLR_30=(tan(30) * sz_v), Y_RAKE_30=(sin(f_rake) * face_len));
        echo(Y_OFF_30=((tan(30) * sz_v) + (sin(f_rake) * face_len) - sz_v));
        */
        
        echo(NEAR_Y=near_y, FAR_Y=far_y, FAR_X=far_x);
        // clear the unused front of the toolbit to prevent artifacts
        cube([sz_h, min(near_y, far_y), sz_v]);
        
        front_face(sz_h, sz_v, f_clr, f_rake);
  
        /* equivalent to:
        translate([near_x + far_x, near_y + far_y, 0]) {
              side_face(sz_h, sz_v, s_edge, s_clr, f_clr,   f_rake, face_len);
        }; */
        side_cutting_edge_and_relief(near_x, near_y, far_x, far_y, sz_h, sz_v, s_edge, s_clr);
    
        /* equivalent to:
         top_face(sz_h, sz_v, b_rake, f_clr, f_rake, s_rake, s_edge_comp, face_len); */
        back_and_side_rake(near_x, near_y, far_x, far_y, sz_h, sz_v, b_rake, s_rake, s_edge);
    };
}

// main():
standard_lathe_toolbit();

/* // DEBUG TOP FACE
// TESTBED
//opp = tan($side_cutting_edge) * ($blank_h - $face_len);
inner_x = calc_face_far_x($end_cutting_edge, $face_len); 
// clear front of tool bit
inner_y = calc_face_near_y($blank_h, $blank_v, $end_relief, $end_cutting_edge, $face_len) + calc_face_far_y($end_cutting_edge, $face_len); 

//translate([0, inner, 0]) cube([$blank_h, inner_y, $blank_v]);
//cube([$blank_h, -inner_y, $blank_v]);

translate([inner_x, -inner_y, $blank_v]) {
    rotate([0, $side_rake, $side_cutting_edge]) {
        // padding: to account for rotation
        //cube([$blank_h/2,$blank_v*2, $blank_v]);
    };
};
*/

/*  // DEBUG FRONT FACE
    f_clr = 180 + $end_relief;
    f_rake = 360 - $end_cutting_edge;

    tan_clr = abs(tan(f_clr));
    y_off_clr = tan_clr * $blank_v;
    z_off_clr = tan_clr * y_off_clr;
    echo(Z_OFF_C=z_off_rake, Y_OFF_C=y_off_rake, TAN=tan_rake);
    
    tan_rake = abs(tan(f_rake));
    y_off_rake = tan_rake * $blank_h;
    z_off_rake = tan_rake * y_off_rake;
    echo(Z_OFF_R=z_off_rake, Y_OFF_R=y_off_rake, TAN=tan_rake);

    
    // NEW Z is too low!
    new_y = -(y_off_clr + y_off_rake - $blank_v) ;
    new_z = $blank_v + z_off_rake + z_off_clr ;
    echo(Z=new_z)

    translate([-2, new_y, new_z]) {

        rotate([f_clr, 0, f_rake]) {
            // padding: to account for rotation
            //cube([$blank_h * 2, $blank_v * 2, $blank_v * 2]);
        };
    };
    */

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
    s_edge_comp = 360 - s_edge;
    
    near_y = calc_face_near_y(sz_h, sz_v, f_clr, f_rake, face_len);
    far_y = calc_face_far_y(f_rake, face_len);
    near_x = 0;
    
    far_x = calc_face_far_x(f_rake, face_len);
    echo(FAR_X=far_x, RAKE=f_rake, LEN=face_len);
   
    ang = f_rake; // WRONG
    
    echo(ANG=ang, TAN=abs(tan(ang)), X=(sz_h - far_x));
    inner_x = ((sz_h - far_x) / abs(tan(ang)));
    echo(INNER_X=inner_x, FAR_X=far_x, H=sz_h);
    //inner_x = far_x; //h; //near_x + h;
    inner_y = min(near_y, far_y) ; //+ (-opp);
    outer_y = max(near_y, far_y) ; 
    
    // back rake
    translate([0, inner_y, sz_v]) {
        //rotate([-b_rake, 0, 0]) cube([sz_h, outer_y, sz_v]);
    }
    translate([inner_x, inner_y, sz_v]) {
        rotate([0, s_rake, s_edge_comp]) {
            translate([0, -0.25, 0.50]) {
                //cube([sz_v, max(near_y, far_y)+ 0.25, sz_h * 2]);
            };
        };
    };
    
   

/*
    side cutting edge 
    side relief 15
    end cutting edge 80
    end relief 15
    back rake 15-18
    side rake 20
    face_len ?
    node radius 1/64
*/