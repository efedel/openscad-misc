//include <BOSL/constants.scad>
include <MCAD/constants.scad>
include <MCAD/triangles.scad>
include <threads.scad>

x = mm_per_inch;
bar_l = mm_per_inch * 6; // 6 inches
bar_h = mm_per_inch * 1; // 1 inch
bar_w = mm_per_inch + 2; // 1 inch
hole_from_end = mm_per_inch * 0.5;
hole_from_center = mm_per_inch * 2.5;
major_diam_6 = mm_per_inch * 0.138;
minor_diam_6 = mm_per_inch * 0.1073;
major_diam_1_4 = mm_per_inch * 0.25;
minor_diam_1_4 = mm_per_inch * 0.219;

module quarter_inch_tapped_hole(depth,tpi=20) {
     
    //difference() {
        cylinder(h=depth+0.2, r=minor_diam_1_4);
        //english_thread(major_diam_1_4, tpi, depth+0.2, internal=true);
    //}
}

module num_6_tapped_hole(depth) {
    difference() {
        cylinder(h=depth+0.2, r=minor_diam_6);
        english_thread(major_diam_6, 32, depth+0.2, internal=true);
    }

}

module clamp_a(h,w,l) {
    //translate([hole_from_end, -0.1, w * 0.5])
    //        rotate([90, 0, 0])
    //            quarter_inch_tapped_hole(h);
    difference() {
        cube([l,h,w]);
        
        //center hole
        translate([hole_from_end + hole_from_center, h+0.2, w * 0.5])
            rotate([90, 0, 0])
                quarter_inch_tapped_hole(h+0.2);
        
        // end blind hole
         translate([hole_from_end + (2 * hole_from_center), h+0.2, w * 0.5])
            rotate([90, 0, 0])
                quarter_inch_tapped_hole(5);
        
        // bevel
        translate([-0.1, -0.1, -0.1])
            triangle((l*0.125) + 0.2, h+0.2, w+0.2, center=false);
        
        // set screw
        translate([hole_from_end + hole_from_center, h * 0.5, 0.5 * (w + major_diam_1_4)])
            num_6_tapped_hole(w * 0.5);
    }
    
}

module clamp_b(h,w,l) {
    difference() {
        cube([l,h,w]);
        
        // 3 x holes
        // FIXME: change this to fine thread
        translate([hole_from_end, h+0.2, w * 0.5])
            rotate([90, 0, 0])
                quarter_inch_tapped_hole(h+0.2, 28);
        translate([hole_from_end + hole_from_center, h+0.2, w * 0.5])
            rotate([90, 0, 0])
                quarter_inch_tapped_hole(h+0.2);
         translate([hole_from_end + (2 * hole_from_center), h+0.2, w * 0.5])
            rotate([90, 0, 0])
                quarter_inch_tapped_hole(h+0.2);
        
        // bevel
        translate([-0.1, -0.1, -0.1])
            triangle((l*0.125) + 0.2, h+0.2, w+0.2, center=false);
    }
    
}

clamp_a(bar_h, bar_w, bar_l);

translate([0, bar_h + 20, 0])
    //rotate([180, 0, 0])
        clamp_b(bar_h, bar_w, bar_l);
