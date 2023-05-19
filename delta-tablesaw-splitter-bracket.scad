include <MCAD/math.scad>

// angle iron: 1x1x 1/8?
//ss||angle|1/8|1|11-3/4||SL||

// block: 2 x 2.25 x 3.24
//steel||rect|2|2-1/4|3-1/4||BR||cross-brace

inch = mm_per_inch;
half_inch = mm_per_inch * 0.5;
quarter_inch = mm_per_inch * 0.25;
eighth = mm_per_inch * (1.0 / 8);
sixteenth = mm_per_inch * (1.0 / 16);

bar_x = mm_per_inch * 2;
// shorten entire Y side by 0.56
bar_y = mm_per_inch * (2.25 - 0.56);
bar_z = mm_per_inch * 3.25;

ang_thick = mm_per_inch * (1.0 / 8);
ang_side = inch;

rod_dia = mm_per_inch * 0.75;
half_rod = rod_dia / 2;

bolt_dia = mm_per_inch * (5.0 / 16);
half_bolt = bolt_dia / 2;



// top of rod to splitter: 1.5"
// top of rod to center of bolt hole: 2.25"
// bottom of angle bracket to center of bolt hole: 1/2"
// top of rod to base of angle bracket: 1.75"
// offset of angle bracket hole center from end of rod: 1/2" + 25/32"
room_for_rod = rod_dia + half_inch;
lop = inch + half_inch + quarter_inch + room_for_rod -
 (mm_per_inch * 0.15); // printed 0.15 too high
conn_bolt_offset = half_inch + (mm_per_inch * (25.0 / 32));

module bracket() {
    difference() {
        cube([bar_x, bar_y, bar_z]);
        
        // reduce height
        translate([0, 0, lop])
            cube([bar_x, bar_y, bar_z - lop]);
        
        // drill hole for 5/16 bolt
        translate([conn_bolt_offset, bar_y - ang_side / 2, lop])
            cylinder(d=bolt_dia, h=bar_z, center=true, $fn=99);
        
        translate([0, bar_y - quarter_inch - eighth , 0])
            cube([bar_x, half_inch, inch]);
        
        translate([0, quarter_inch + half_rod, half_inch + half_rod])
            rotate([0, 90, 0])
                cylinder(d=rod_dia, h=bar_x, $fn=99);
        
        translate([0, quarter_inch + half_rod - (sixteenth / 2), 0])
                cube([bar_x, sixteenth, half_inch + 1]);
        
        translate([(bar_x - half_inch - half_bolt), 0, quarter_inch])
            rotate([90, 0, 0])
                cylinder(d=bolt_dia, h=bar_y, center=true, $fn=99);
    }
}

module angle_bracket() {
    union() {
        difference() {
            translate([-(ang_side+20), 0, 0])
                cube([ang_side, ang_side, ang_thick]);
            translate([-((ang_side / 2) + 20), ang_side / 2, 0])
                cylinder(d=bolt_dia, h=(ang_thick+1), $fn=99);
        }
        
        difference() {
            translate([-(ang_side+20), ang_side, 0])
                rotate([90, 0, 0])
                    cube([ang_side, ang_side, ang_thick]);
            translate([-((ang_side / 2) + 20), ang_side - 2, ang_side / 2])
                rotate([90, 0, 0])
                    cylinder(d=bolt_dia, h=(ang_thick+2), center=true, $fn=99);
            
        }
    }
}

union() {
    bracket();
    //angle_bracket();
}

