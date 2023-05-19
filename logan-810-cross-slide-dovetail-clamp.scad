/* dimensions of metal stock */
// length of stock in mm
$stock_x = 87.63; // [10.0:200.0]
// height of stock in mm
$stock_y = 25.4;  // [10.0:150.0]
// width of stock in mm
$stock_z = 15.875;  // [4.0:50.0]
/* dovetail dimensions */
// dovetail angle (usually 60)
$dove_angle = 60; //[30:70]
// widest part of the dovetail, in mm
$dove_max_width = 46.228;  // [5.0:150.0]
// depth of dovetail, in mm
$dove_depth = 12.7; // [5.0:100.0]
// width of the movable/clamp end in mm (minus dovetail overhang)
$clamp_width = 20.701;  // [5:100.0]
// gap made by virtual slitting saw
$slice_width = 0.80; // [0.04:4.0]
// diameter of hole for threaded clamping rod
$clamp_rod_dia = 6.35; // [1.0:15.0]
/* 
   NOTE: 6.35 for 1/4, 4.978 for #10, 4.305 for #8, 3.657 for #6
*/

dove_overhang = ($dove_depth / tan($dove_angle));
dove_x_offset = $clamp_width + ($dove_max_width / 2);
slice_location = dove_x_offset + ($dove_max_width / 2) - 
                 dove_overhang - $slice_width;

difference() {
    // the hunk of metal:
    cube([$stock_x, $stock_y, $stock_z]);
    translate([0, $stock_y - $dove_depth, 0]) {
        min_width = $dove_max_width - (2*dove_overhang);       
        // make a 3D dovetail from a 2D outline
        linear_extrude(height=$stock_z, convexity=2) {
            translate([dove_x_offset, $dove_depth, 0]) {
                rotate([0,0,180]) {
                    // the actual dovetail shape:
                    polygon(paths=[[0,1,2,3,0]], 
                            points=[[-min_width/2,0], 
                                    [-$dove_max_width/2, $dove_depth + 0.001], 
                                    [$dove_max_width/2, $dove_depth + 0.001], 
                                    [min_width/2,0]]);
                };
            };
        };
    };
    
    // the bore for the clamping threaded rod:
    translate([0, (($stock_y - $dove_depth) / 2), ($stock_z / 2)]) {
        rotate([0, 90, 0]) {
            cylinder(h=$stock_x, r=($clamp_rod_dia / 2), $fn=99);
        };
    };
    
    // slit with a slitting saw:
    translate([ slice_location, 0, 0 ]) {
            cube([$slice_width, ($stock_y - $dove_depth), $stock_z+5]);
    };
};