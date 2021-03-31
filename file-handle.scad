// 8-10" : 4.41 x 2.76 x 1.18 inches
// 4-6" : : 4 x 1 x 1 i
// 2.5 : 63.5
$length = 110; //114.3;
$diameter = 28.75; //38.1; //1.5"
$shank = 3.175; // 1/8"
$shank_len = 40;


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
        //difference() {
            sphere(r=r);
            //cylinder(r1=(r* 0.4), r2=(r * 0.4), h=(r*4), $fn=7);
        //};
    };
}

module palm_bulb(y_offset, palm_rad) {
    translate([0, y_offset, 0]) {
        scale([0.80,1.95,0.80]) {
            sphere(r=palm_rad);
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
ridge_width = 3.25;
t_width = 2.75;
t_depth = 20; // trough depth
cyl_3rd_dia = $diameter / 3;


difference() {
    translate([$diameter, 0, 0]) {
        union() {
            base_handle(cyl_rad, cyl_len, 8);   
            palm_bulb(hilt_width + 47, 21);
            pommel(pom_rad, $length-(2* pom_rad));
        };
    };

    thumb_groove(hilt_width);
    
    // grip cutouts
    // 12.times
    
    translate([$diameter, hilt_width, 0]) {
        for (i = [0 : 10]) {   
            translate([-cyl_rad, i*(ridge_width + 2.75), 0]) {
                
                // LEFT
                translate([-ridge_width, 0, 0]) {
                    translate([0,0,$shank]) 
                        cube([cyl_3rd_dia, t_width, t_depth]); // top
                    translate([0,0,-($shank + t_depth)]) 
                        cube([cyl_3rd_dia, t_width, t_depth]); //bottom
                };
                    
                //CENTER
                translate([cyl_3rd_dia, 0, 0]) {
                    translate([0,0,$shank]) 
                        cube([cyl_3rd_dia, t_width, t_depth]); // top
                    translate([0,0,-($shank + t_depth)]) 
                        cube([cyl_3rd_dia, t_width, t_depth]); //bottom
                };
                
                // RIGHT
                translate([(2*cyl_3rd_dia)+ridge_width, 0, 0]) {
                    translate([0,0,$shank]) 
                        cube([cyl_3rd_dia, t_width, t_depth]); // top
                    translate([0,0,-($shank + t_depth)]) 
                        cube([cyl_3rd_dia, t_width, t_depth]); //bottom
                };
           
            };
        }
    };
    
    // clean up pommel
    translate([$diameter, $length-(2* pom_rad) - 3, 0]) {
        rotate([90,0,0]) {
            rotate_extrude(convexity=10, $fn = 100)   {     
                translate([($diameter* 0.6), 0, 0]) {
                    circle(r=4, $fn=100);
                }
            }
        }
    }
    
    // pommel hole
    translate([$diameter, $length-(2* pom_rad), -(pom_rad*2)]) {
        rotate([0,0,90])
            cylinder(r1=(pom_rad* 0.4), 
                    r2=(pom_rad * 0.4), 
                    h=(pom_rad*4), $fn=7);

    };
    
    // hole for file
    translate([$diameter, -0.05, 0]) {
        rotate([270, 0, 0]) {
            cylinder(r1=$shank, r2=($shank *0.75), h=$shank_len);
        };
    }
};
