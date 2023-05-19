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

module bushing_label_lame(label, dia, h) {
    radius = (dia * 0.5);
    ht = h * 0.5;
   
    // evenly-spaced letters:
    step_angle = 360 / len(label);
    circumference = 2 * PI * radius;
    char_size = circumference / (len(label));
   
    
    for(i = [0 : len(label) - 1]) {
        pos = radius + char_size / 2;
        rotate(i * step_angle) 
            translate([0, 0, h*0.5])
                translate([0, pos]) 
                    rotate([90, 0, 180]) linear_extrude(6) text(label[i], font = "Courier New; Style = Bold", size = char_size, valign = "center", halign = "center"
                );
    }
}

module bushing_label_orig(label, dia, h) {
    // extrude for 1.5, to allow depth of 0.75 for letters
    radius = (dia * 0.5);
    ht = h * 0.5;
   
    step_angle = 45;
    char_size = 5; //circumference / (len(label));
    // evenly-spaced letters:
    //step_angle = 360 / len(label);
    //circumference = 2 * PI * radius;
    //char_size = circumference / (len(label));
   
    
    for(i = [0 : len(label) - 1]) {
        //pos = radius + char_size / 2;
        pos = radius + (char_size / 2) - 0.75;
        //pos = radus + char_size - 0.75;
        rotate(i * step_angle) 
            translate([0, 0, h*0.5])
                translate([0, pos]) 
                    rotate([90, 0, 180]) linear_extrude(6) text(label[i], font = "Courier New; Style = Bold", size = char_size, valign = "center", halign = "center"
                );
    }
}
module bushing_label(label, dia, h) {
    // extrude for 1.5, to allow depth of 0.75 for letters
    radius = (dia * 0.5);
    ht = h * 0.5;
   
    //step_angle = 45;
    char_size = 5; 
    
    // calculate total number of characters
    // that *could* be on circumference,
    // in order to get per-character step angle
    circumference = 2 * PI * radius;
    circ_chars = circumference / char_size;
    step_angle = 360 / circ_chars;   
    
    for(i = [0 : len(label) - 1]) {
        pos = radius + (char_size / 2);
        //pos = radius + (char_size / 2) - 0.75;
        //pos = radus + char_size - 0.75;
        rotate(i * step_angle) 
            translate([0, 0, h*0.5])
                translate([0, pos]) 
                    rotate([90, 0, 180]) linear_extrude(6) text(label[i], font = "Courier New; Style = Bold", size = char_size, valign = "center", halign = "center"
                );
    }
}
module base_bushing(dia, label, length=1) {
    union() {
       ht = (length * mm_per_inch);
       cylinder(d=dia, h=ht, $fn=999);
       difference() {
        cylinder(d=(dia*2), h=(ht * 0.5),$fn=999); 
        bushing_label(label, dia, ht * 0.5);
       }
    }
}

// 8mm bushing
// needs 1/4" arbor
translate([10, 0, 0]) {
    difference() {
        base_bushing(8, "8mm", $fn=99);
        small_arbor();
    }
}

// 7mm bushing
// comfort, all other bushings
translate([-15, 0, 0]) {
    difference() {
        base_bushing(7, "7mm", $fn=99);
        small_arbor();
    }
}

//11mm
translate([-40, 0, 0]) {
    difference() {
        base_bushing(11, "11mm", $fn=99);
        arbor();
    }
}

// 3/8
// vertex, stratus
translate([40, 0, 0]) {
    difference() {
        base_bushing(((3.0/8.0)* mm_per_inch), "3/8", $fn=99);
        arbor();
    }
}

// 36/64, 15/32
// jr gentleman pen
translate([70, 0, 0]) {
    difference() {
        base_bushing(((36.0/64.0)* mm_per_inch), "36/64", $fn=99);
        arbor();
    }
}

translate([-100, 0, 0]) {
    difference() {
        base_bushing(((15.0/32.0)* mm_per_inch), "15/32", $fn=99);
        arbor();
    }
}

// 23/64 
//professor pen kit
translate([-70, 0, 0]) {
    difference() {
        base_bushing(((23.0/64.0)* mm_per_inch), "23/64", $fn=99);
        arbor();
    }
}

/*
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
translate([40, 40, 0]) {
    difference() {
        cone();
        arbor();
    }
}

translate([-40, -40, 0]) {
    difference() {
        cone();
        small_arbor();
    }
}
*/