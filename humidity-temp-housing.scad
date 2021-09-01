
board_x = 25.57;
board_y = 50.31;
wall_thickness = 2.25;
corner_rad = 7.0 / 2;
front_height = 17;
lcd_ridge_height = 4; //4.5;
lcd_hole_x_len = 15.0;
lcd_hole_y_len = 23.0;
lcd_hole_x = 4.35;
lcd_hole_y = 7;
lcd_x_frame = 2.5;
lcd_y_frame = 6.0;
lcd_x_len = 20;
lcd_y_len = 25.75;
control_y = 14.75;



// front
module front_outside() {
    difference() {
        union() {
            cube([board_x + (2* wall_thickness),
                board_y + (2 * wall_thickness),
                    front_height + wall_thickness]);
            cylinder(r=corner_rad, h=(front_height+wall_thickness), $fn=66);
            translate([board_x + (2*wall_thickness), 0, 0]) cylinder(r=corner_rad, h=(front_height+wall_thickness), $fn=66);
            translate([0, board_y + (2*wall_thickness), 0]) cylinder(r=corner_rad, h=(front_height+wall_thickness), $fn=66);
            translate([board_x + (2*wall_thickness), board_y + (2*wall_thickness), 0]) cylinder(r=corner_rad, h=(front_height+wall_thickness), $fn=66);           
        }
        cylinder(r=1.3, h=(front_height + wall_thickness + 0.01), $fn=66);
        translate([board_x + (2*wall_thickness), 0, 0]) cylinder(r=1.3, h=(front_height + wall_thickness + 0.01), $fn=66);
        translate([0, board_y + (2*wall_thickness), 0]) cylinder(r=1.3, h=(front_height + wall_thickness + 0.01), $fn=66);
        translate([board_x + (2*wall_thickness), board_y + (2*wall_thickness), 0]) cylinder(r=1.3, h=(front_height + wall_thickness + 0.01), $fn=66);
    
    }
}

module front() {
    difference() {
        front_outside();
    
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
        translate([wall_thickness + 4 + 1, 
                   wall_thickness + board_y - 3.5, 
                   -0.1])
            cylinder(d=2, h=wall_thickness+0.1);
            
        // rst: 2mm dia @ (board_x - 4.47),(board_y-3.5)
        translate([wall_thickness + board_x - 4.5 + 1, 
                   wall_thickness + board_y - 3.5, 
                   -0.1])
            cylinder(d=2, h=wall_thickness+0.1);
        // usb: 9.25mm from either edge, 3.25 high
        translate([wall_thickness + 9.25, wall_thickness + board_y -0.01, wall_thickness])
            cube([7.50, wall_thickness + 0.01, 3.25]);

        // vents!
        for ( i = [1:1:6] ) {
            translate( [-0.5, wall_thickness + 2 + (i * 5), wall_thickness + lcd_ridge_height])
                rotate([0,0,-30])
                    cube([wall_thickness + 1, 2.5, 10]);
            translate( [board_x + wall_thickness -0.5, wall_thickness + 2 + (i * 5), wall_thickness + lcd_ridge_height])
                rotate([0,0,-30])
                    cube([wall_thickness + 1, 2.5, 10]);
        }
        
    }


}

front();
