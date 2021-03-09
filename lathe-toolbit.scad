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

$pad = 0.001;

// 1 : side rake
//   1.1 : triangle to get coords of pivot point
opp = ($blank_h - $face_len);
//b = $blank_h;
scea = 270-$side_cutting_edge;
adj = opp / tan($side_cutting_edge);
//echo(H=$blank_h, L=$face_len, ADJ=c,OPP=a,A=scea,TAN_A=tan($side_cutting_edge));
// pivot point is now ($blank_h, cadj $blank_v)
sce_pivot_x = $blank_h;
sce_pivot_y = adj;
sce_pivot_z = $blank_v;
sce_length = opp / sin($side_cutting_edge); //c; // fixme: h!
sce_width = opp;

// 2: side relief
sr_length = sce_length * 1.5; //FIXME
sr_width = sce_width * 1.5; //FIXME
sr_height = (2 * $blank_v); //FIXME
// 3: side rake

// front cutting edge
f_adj = $face_len;
f_opp = (tan($end_cutting_edge) * f_adj);
f_h = f_adj / cos($end_cutting_edge);
// front relief
fr_adj = $blank_v;
fr_opp = (tan($end_relief) * fr_adj);
fr_h = fr_adj / cos($end_relief);
    
// unused:
module rotate_about_pt(arr, pt) {
    translate(pt)
        rotate(arr)
            translate(-pt)
                children();   
}

difference() {
    // toolbit blank
    cube([$blank_h, $blank_len, $blank_v]);
    
    // side cutting edge
    if ($side_cutting_edge != 0) {
        // note + 0.001 to prevent artifacts
        translate([sce_pivot_x, sce_pivot_y, -$pad])
            rotate([0,0,scea])
                cube([sce_length, sce_width, $blank_v + (2*$pad)]); 
    }
     
    // side relief
    if ($side_relief != 0) {
        translate([sce_pivot_x, sce_pivot_y, -$pad])
            rotate([0,0,scea])
                // NOTE: we are increasing assumed-size from blank_v to sr_height
                translate([(sce_width), 0, $blank_v])
                    rotate([360-$side_relief,0, 0])
                        translate([-(sce_width), 0, -sr_height])
                            cube([sr_length, sr_width, sr_height + ($pad)]); 
    }
    
    // side rake
    if ($side_rake != 0) {
        // FIXME: difference out back of tool
        translate([sce_pivot_x, sce_pivot_y, $blank_v])
        rotate([90, 0, scea])
        rotate([$side_rake, 0])
        cube([sce_pivot_x, sce_pivot_y, sr_height]);
    }

    if ($end_cutting_edge != 0) {
        translate([$face_len, -f_opp, 0])
            // replace / 2 with half-f-opp for rotation
            translate([0, (f_opp / 2), 0])
                rotate([0,0,180 - $end_cutting_edge]) 
                    translate([0, -(f_opp / 2), 0])
                        // FIXME: $pad is not enough
                        // FIX the +1 +2 +3
                        cube([$face_len + 1 , f_opp + 3, $blank_v + 2]);
    }

    if ($end_relief != 0) {
        // FIXME: TF the deal with 0.4
        translate([$face_len, fr_opp - 0.4, 0])
            translate([fr_opp, 0, 0])
                rotate([360-$end_relief,0, 180 - $end_cutting_edge]) 
                    translate([-fr_opp, 0, 0])
                        cube([f_h * 2, fr_opp * 2, fr_h]); 
        /*
            translate([$face_len, f_opp - 0.6 , 0])
       translate([fr_opp, (f_opp / 2), 0])
      rotate([360-$end_relief,0, 180 - $end_cutting_edge]) 
        translate([-fr_opp, -(f_opp / 2), 0])
        cube([f_h * 2, fr_opp * 2, fr_h]); 
      */
    }

    // back rake
    if ( $back_rake != 0 ) {
        //translate([$face_len, fr_opp - 0.4, 0])
        
    }
}


/*
        translate([$face_len, fr_opp, $blank_v])
            //translate([0, (f_opp / 2), 0])
                rotate([$back_rake, $side_relief, 180 - $end_cutting_edge]) 
                    //translate([-fr_opp, 0, 0])
                        cube([f_h * 2, fr_opp * 2, fr_h]); 
*/