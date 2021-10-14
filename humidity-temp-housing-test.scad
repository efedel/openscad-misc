
board_x = 25.57 + 0.2;
board_y = 50.31 + 0.2;
wall_thickness = 2;
corner_rad = 7.0 / 2;
front_height = 17;
lcd_ridge_height = 2.75; //1.5; //4.5;
lcd_hole_x_len = 15.0;
lcd_hole_y_len = 23.4;
lcd_hole_x = 3; //1.5; //4.35;
lcd_hole_y = 6.6; //7;
lcd_x_frame = 2.5;
lcd_y_frame = 6.0;
lcd_x_len = 20;
lcd_y_len = 25; //25.75;
control_y = 17; //14.75;

back_height = wall_thickness;

// NOTE: this is from top of base piece
standoff_height = 12.0; //12mm to circuit board
standoff_x = 8.23; // 8mm, roughly
standoff_y = 1.5; // less than 2mm
standoff_z = standoff_height + 4; 
standoff_a_y = 3.0; // 3mm
standoff_b_y = 16.5; // 16.5mm
sensor_z = 4.5; //standoff_height - 1.0; // 8mm
sensor_x = 15; // 15mm
sensor_y = 30.2; // 30mm
sensor_peg_dia = 2.5; //3; // 2.75mm;
sensor_peg_x = sensor_x - 6.75 - (sensor_peg_dia / 2) + 0.25 + 1.21; // 1.21 : correction by measurement
peg_len = 3.0;

module outside(height) {
    difference() {
        union() {
            cube([board_x + (2* wall_thickness),
                board_y + (2 * wall_thickness),
                    height + wall_thickness]);
            cylinder(r=corner_rad, h=(height+wall_thickness), $fn=66);
            translate([board_x + (2*wall_thickness), 0, 0]) cylinder(r=corner_rad, h=(height+wall_thickness), $fn=66);
            translate([0, board_y + (2*wall_thickness), 0]) cylinder(r=corner_rad, h=(height+wall_thickness), $fn=66);
            translate([board_x + (2*wall_thickness), board_y + (2*wall_thickness), 0]) cylinder(r=corner_rad, h=(height+wall_thickness), $fn=66);           
        }
        cylinder(r=1.3, h=(height + wall_thickness + 0.01), $fn=66);
        translate([board_x + (2*wall_thickness), 0, 0]) cylinder(r=1.3, h=(height + wall_thickness + 0.01), $fn=66);
        translate([0, board_y + (2*wall_thickness), 0]) cylinder(r=1.3, h=(height + wall_thickness + 0.01), $fn=66);
        translate([board_x + (2*wall_thickness), board_y + (2*wall_thickness), 0]) cylinder(r=1.3, h=(height + wall_thickness + 0.01), $fn=66);
    
    }
}

module front() {
    difference() {
        outside(front_height);
    
        //lcd hole
        translate([wall_thickness + lcd_hole_x, 
               wall_thickness + lcd_hole_y, -0.1])
            cube([lcd_hole_x_len, lcd_hole_y_len, front_height + wall_thickness]);
        // board support/lcd frame
        translate([wall_thickness + lcd_x_frame, wall_thickness + lcd_y_frame, wall_thickness])
            cube([lcd_x_len, lcd_y_len, lcd_ridge_height]);
        // control cutout
        translate([wall_thickness, wall_thickness + board_y - control_y, wall_thickness])
            cube([board_x, control_y, lcd_ridge_height]);
        
        // board cutout
        translate([wall_thickness, wall_thickness, wall_thickness + lcd_ridge_height])
            cube([board_x, board_y, front_height]);
        
        // LED: 4x1.5 @ 5 in x 13 in y
        translate([wall_thickness + 5, 
                   wall_thickness + board_y - 13, 
                   -0.1])
            cube([4, 1.5, wall_thickness+0.1]);
        
        // prg: 2mm dia @ (board_x - 4),(board_y-3.5)
        translate([wall_thickness + 4,  
                   wall_thickness + board_y - 3.5, 
                   -0.1])
            cylinder(d=4, h=wall_thickness+0.1, $fn=33);
            
        // rst: 2mm dia @ (board_x - 4.47),(board_y-3.5)
        translate([wall_thickness + board_x - 4.5,  
                   wall_thickness + board_y - 3.5, 
                   -0.1])
            cylinder(d=4, h=wall_thickness+0.1, $fn=33);
            
        // usb: 9.25mm from either edge, 3.25 high
        translate([wall_thickness + 8.25, 
                   wall_thickness + board_y -0.01, wall_thickness])
            cube([9.50, wall_thickness + 0.01, 3.25]);

        // vents!
        for ( i = [1:1:6] ) {
            translate( [-1.5, wall_thickness + 1 + (i * 5), wall_thickness + lcd_ridge_height])
                rotate([0,0,-30])
                    cube([wall_thickness + 2, 2.5, 10]);
            translate( [board_x + wall_thickness -1.5, wall_thickness + 2 + (i * 5), wall_thickness + lcd_ridge_height])
                rotate([0,0,-30])
                    cube([wall_thickness + 2, 2.5, 10]);
        }
        
    }


}
module standoffs() {
    translate([wall_thickness, standoff_a_y-1, 0])
        cube([(board_x / 2)+(standoff_x / 2), standoff_y+1, standoff_z]);
    
    translate([wall_thickness+sensor_x - 3, board_y - standoff_b_y, 0])
        cube([standoff_x+5.5, standoff_y, standoff_z]);
}

module ledge() {
            translate([wall_thickness,
               wall_thickness,
               wall_thickness + standoff_z - sensor_z])
                cube([wall_thickness+4, sensor_y / 2, standoff_y + 1]);
 
            translate([wall_thickness,
               wall_thickness,
               wall_thickness])
                cube([wall_thickness, sensor_y / 2, standoff_z - sensor_z]); 

        translate([ wall_thickness + sensor_peg_x,
                wall_thickness + 4 + 21.5,
               wall_thickness])
        cylinder(d=sensor_peg_dia, h=peg_len, $fn=99);
}

module back_face() {

    difference() {
        
        union() {
        
            outside(back_height);
   
            translate([wall_thickness, wall_thickness, wall_thickness])
                cube([board_x, board_y, 4]);
        }        
        
        // cutout
        translate([wall_thickness + 2, wall_thickness + 2, wall_thickness])
                cube([board_x - 4, board_y - 4, 4]);
        
        // vents!
        for ( i = [0:1:9] ) {
            translate([wall_thickness + ((board_x - 17) / 2) + (i * 2), board_y - standoff_b_y + standoff_y + 1, -0.1])
                cube([1, board_y / 4.0, wall_thickness +  0.1 ]);
            
        }
        
        // sensor cutout
        translate([wall_thickness + 2, wall_thickness+2.6, -0.1])
            cube([13, 17, wall_thickness+4]);
        
        // vents!
        for ( i=[1:1:4] ) {
            translate([wall_thickness + 14.5 + (i*2), wall_thickness+2.6, -0.1])
                cube([1, 17, wall_thickness +  0.1 ]);
        }

    }
}

module back() {
    union() {
        back_face();
        standoffs();
        ledge();
        
        
    }
}

// uncomment to print front:
front();    

// to print front and back on same STL:
translate([-50, 0, 0])
  // uncomment to print housing back:
  back();
