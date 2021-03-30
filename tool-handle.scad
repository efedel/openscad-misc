// 8-10" : 4.41 x 2.76 x 1.18 inches
// 4-6" : : 4 x 1 x 1 i
// 2.5 : 63.5
$length = 110; //114.3;
$diameter = 28.75; //38.1; //1.5"


// width of hilt: 7.75
// concave radius size: 25mm reduce dia to 21
// convex radiud : 40mm increase dia to 30.5
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
            pommel(pom_rad, $length-(2* pom_rad));
        };
    };

    thumb_groove(hilt_width);
};
