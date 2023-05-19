include <MCAD/math.scad>                                                        
PI = 3.14159;
pad=0.02; // to account for filament swelling

module arbor() {
    arbor_dia = (((5.0 / 16)+0.003) * mm_per_inch) + pad;
    translate([0,0,-1])
    cylinder(d=arbor_dia, h=(6 * mm_per_inch), $fn=999);
}


module small_arbor() {
    arbor_dia = (((1.0 / 4)+0.003) * mm_per_inch) + pad;
    cylinder(d=arbor_dia, h=(6 * mm_per_inch), $fn=999);
}


module cone() {
    angle = 45.0;
    opp = 10.0; // radius
    len = opp / tan(angle);
    union() {       
        cylinder(r=10, h=(1.5 * mm_per_inch), $fn=999);
        translate([0,0, (1.5 * mm_per_inch) - 0.1])
            cylinder(r1=10, r2=0, h=len, $fn=999);
    }
}

// basic cone to fit into steady
translate([15, 0, 0]) {
    difference() {
        cone();
        arbor();
    }
}

translate([-15, 0, 0]) {
    difference() {
        cone();
        small_arbor();
    }
}
