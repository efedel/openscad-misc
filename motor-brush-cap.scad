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
include <scad-utils/transformations.scad>

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

// https://hackaday.io/page/5252-generating-nice-threads-in-openscad
module straight_thread(section_profile, pitch = 4, turns = 3, r=10, higbee_arc=45, fn=120)
{
	$fn = fn;
	steps = turns*$fn;
	thing =  [ for (i=[0:steps])
		transform(
			rotation([0, 0, 360*i/$fn - 90])*
			translation([0, r, pitch*i/$fn])*
			rotation([90,0,0])*
			rotation([0,90,0])*
			scaling([0.01+0.99*
			lilo_taper(i/turns,steps/turns,(higbee_arc/360)/turns),1,1]),
			section_profile
			)
		];
	skin(thing);
}
// radial scaling function for tapered lead-in and lead-out
function lilo_taper(x,N,tapered_fraction) =     min( min( 1, (1.0/tapered_fraction)*(x/N) ), (1/tapered_fraction)*(1-x/N) )
;

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
}

thrd_height = mm_per_inch * ((0.5625 - 0.4964) / 2); 
thrd_turns = 3;
thrd_major = mm_per_inch * 0.5625;
thrd_pitch = 1.411; // 0.05556 in
thrd_prof = [
    [0, 0],
    [0, 1.42],
    [thrd_height, 1.22],
    [thrd_height, 0.22] 
];

translate([25,25,25]) {
   union(){
     straight_thread(
        section_profile = thrd_prof,
        higbee_arc = 20,
        r     = thrd_major/2,
        turns = thrd_turns,
        pitch = thrd_pitch,
        fn    = $fn
     );
   }
 }