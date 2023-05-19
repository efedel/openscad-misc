include <MCAD/math.scad>
inch = mm_per_inch;
half_inch = mm_per_inch * 0.5;
quarter_inch = mm_per_inch * 0.25;
eighth = mm_per_inch * 0.125;
sixteenth = mm_per_inch * 0.0625;

difference() {
    // base and tabs
    union() {
        cube([inch, inch+half_inch, sixteenth]);
        translate([half_inch + quarter_inch,  sixteenth + (2*quarter_inch), 0]) {
            
            cylinder(d=quarter_inch, h=eighth, $fn=99);
            translate([0, quarter_inch+sixteenth, 0])
                cylinder(d=eighth, h=eighth, $fn=99);
            
            translate([0, half_inch + eighth, 0])
                cylinder(d=sixteenth, h=eighth, $fn=99);
        }
        
        translate([eighth, inch+half_inch-eighth, 0])
            cube([half_inch, sixteenth, eighth]);
    }
    
    // holes
    translate([quarter_inch, half_inch, 0])
        cube([eighth, eighth, sixteenth]);
    
    translate([eighth, half_inch + quarter_inch, 0])
        cube([half_inch, half_inch, sixteenth]);
    
    translate([sixteenth, sixteenth, 0])
        cube([half_inch, quarter_inch, sixteenth]);
    
    translate([half_inch + quarter_inch, quarter_inch, 0]) {
        cylinder(d=quarter_inch, h=sixteenth, $fn=99);
    
        translate([0, half_inch + quarter_inch + sixteenth, 0])
            cylinder(d=eighth, h=sixteenth, $fn=99);
        translate([0, inch+sixteenth, 0])
              cylinder(d=sixteenth, h=sixteenth, $fn=99);    
    }
}