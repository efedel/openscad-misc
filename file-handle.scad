// 8-10" : 4.41 x 2.76 x 1.18 inches
// 4-6" : : 4 x 1 x 1 i
// 2.5 : 63.5
$length = 110; //114.3;
$diameter = 28.75; //38.1; //1.5"


// width of hilt: 7.75
// concave radius size: 25mm reduce dia to 21
// convex radius : 40mm increase dia to 30.5
// sphere on end: 28mm, 16x18mm cutout
// grip ridge 3.23 trough 2.75 12 total

major_dia = $diameter + ($diameter * 0.24);
minor_dia = $diameter - ($diameter * 0.24);

module base_handle(c_rad, c_len, sides) {
    translate([0, c_len, 0]) {
        rotate([90, 0, 0]) {
        cylinder(h=c_len, r1=c_rad, r2=c_rad, $fn=sides);
        };
    };
}

module pommel(r, pos) {
    translate([0, pos, 0]) {
        difference() {
            sphere(r=r);
            //translate([0, pos + pos, 0]);
            //cube([16, r*2, 18]);
        };
    };
}

module palm_bulb(sz_palm, palm_rad) {
    // TODO: sphere of palm0bulge size removed from cube
    //translate([($length - sz_palm), -palm_rad, 0]) {
    //translate([0, sz_palm, 0]) {
    /*
    rotate([90,0,0]) {
        rotate_extrude(convexity=10, $fn = 100) {
            translate([0, sz_palm, 0]) {
                difference() {    
                    square(2*palm_rad);
                    translate([palm_rad, 0]) {
                        circle(r=palm_rad);
                    };
                };
            };
       };
    };*/
    difference() {
        cube([(2*palm_rad) + 0.5, sz_palm, (2*palm_rad )+ 0.5]);
        translate([palm_rad, palm_rad, palm_rad]) {
            scale([1.0,2.75,0.85]) {
                sphere(r=palm_rad);
            };
        };
    };
}

module thumb_groove(hilt_width) {
    hole_rad = 10;
    circ_rad = 25;
    translate([$diameter, hilt_width + hole_rad, 0])
        rotate([90, 0, 0])
            rotate_extrude(convexity=10, $fn = 100)        
                translate([hole_rad + circ_rad, 0, 0])
                    circle(r=circ_rad, $fn=100);
}

pom_rad = 14;
cyl_len = ($length - (2 *  pom_rad));
cyl_rad = $diameter / 2;
hilt_width = 7.75;

difference() {
    translate([$diameter, 0, 0]) {
        union() {
            base_handle(cyl_rad, cyl_len, 8);   
            translate([0, hilt_width + 47, 0]) {
                scale([0.80,1.95,0.80]) {
                    sphere(r=21);
                };
            };
            pommel(pom_rad, $length-(2* pom_rad));
        };
    };

    thumb_groove(hilt_width);
    
    translate([$diameter-20.5, hilt_width + 20, -20.5]) {
        //palm_bulb(52, 20.5);
    };
    // grip cutouts
    // pommel hole
    
};

