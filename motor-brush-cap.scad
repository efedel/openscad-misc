// measured:
//cap_dia = 16.55; // 16.6624
//shoulder_dia = 15.88; // 15.7226
//shoulder_depth = 1.82; // 1.7272
//root_dia = 14.52; // 12.60856 doc
//crest_dia = 13.09624; //12.40 // ; 
//cap_len = 10; // 9.525 doc
//cap_top=5.30; // 4.7498 doc
//hole_dia = 2.34; // 1.5748 doc
//slot_depth = 1.59; // 1.5748 doc
//slot_width = 1.66; //1.5748 doc
//base_dia = 9.25; // 9.525 doc
//base_depth = 0.8 ; //0.7874 doc

include <MCAD/math.scad>
//include <scad-utils/transformations.scad>
include <threads.scad>


// document:
cap_dia = mm_per_inch * 0.656;
shoulder_dia = mm_per_inch * 0.619;
shoulder_depth = mm_per_inch * 0.068;
root_dia = mm_per_inch * 0.4964;
crest_dia = mm_per_inch *  0.5156; // 9/16-18
cap_len = mm_per_inch * 0.375;
cap_top= mm_per_inch * (0.375 - 0.188);
hole_dia = mm_per_inch * 0.062;
slot_depth = mm_per_inch * 0.062;
slot_width = mm_per_inch * 0.062;
base_dia = mm_per_inch * 0.375;
base_depth = mm_per_inch * (0.219 - 0.188) ;//.031

thrd_height = mm_per_inch * ((0.5625 - 0.4964) / 2); 
thrd_turns = 3;
thrd_major = mm_per_inch * 0.5625;
thrd_pitch = 1.411; // 0.05556 in
thrd_len = 0.1666; // 0.1666 is 3/18
thrd_prof = [
    [0, 0],
    [0, 1.42],
    [thrd_height, 1.22],
    [thrd_height, 0.22] 
];

difference() {
    cylinder(r=(cap_dia / 2), h=cap_len, $fn=99);
    cylinder(r=(crest_dia / 2), h=(cap_len-cap_top), $fn=99);
    cylinder(r=(hole_dia / 2), h=(cap_len+ 1), $fn=33);
    cylinder(r=(base_dia / 2), h=(cap_len-cap_top+base_depth), $fn=99);
    translate([-(slot_width/2), -(cap_dia / 2) - 0.5, cap_len-slot_depth]) {
        cube([slot_width, cap_dia + 1, slot_depth]);
    } 
    rotate_extrude($fn=99) {
        translate([(shoulder_dia/2), 0, 0])
            square(shoulder_depth);
    }
    translate([0, 0, 0.5]) {
        english_thread(diameter=9/16, threads_per_inch=18, length=thrd_len, internal=true);
    }
}


//translate([15,0,0]) {
//    difference() {
//        cylinder(r=((mm_per_inch * 0.5625) / 2), thrd_len+1);
//        english_thread(diameter=9/16, threads_per_inch=16, length=thrd_len, internal=true);
//    }   
// }