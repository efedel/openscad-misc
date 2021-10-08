include <MCAD/math.scad>

base_side_len = mm_per_inch * 5.8;
base_height = mm_per_inch * 0.1785;
base_z = -(base_height / 2);
base_overhang = mm_per_inch * 0.1945;

grill_side_len = base_side_len - (2 * base_overhang);
grill_height = mm_per_inch * 0.3710;
grill_pad = mm_per_inch * 0.375;
//grill_z = base_z + (grill_height / 2);
grill_z = base_z + base_height + (grill_height / 2);
grill_origin = -(base_side_len / 2) + grill_pad;

total_height = base_height + grill_height;

rect_y = mm_per_inch * 1.57;
rect_x = mm_per_inch * 0.25;
rect_x_pad = mm_per_inch * 0.285; //0.1586;
rect_y_pad = mm_per_inch * 0.185;

cyl_dia = mm_per_inch * 0.4645;
hole_dia = mm_per_inch * 0.25;
cyl_cutout_dia = cyl_dia - (mm_per_inch * 0.16);
cyl_z = base_z + (total_height / 2);
cyl_offset = mm_per_inch * 0.25;

echo("BASE", base_side_len);
echo("GRILL PAD", grill_pad);
echo("GRILL ORIGIN", grill_origin);
echo("RECT X", rect_x, "RECT Y", rect_y);
echo("RECT X PAD", rect_x_pad, "RECT Y", rect_y_pad);
echo("GRILL X", grill_side_len, "X cutout", rect_x,  "X PAD", rect_x_pad);
echo("GRILL Y", grill_side_len, "Y cutout", rect_y,  "Y PAD", rect_y_pad);
echo("BASE Z", base_z, "BASE HEIGHT", base_height, "BASE TOP", base_z + base_height);
echo("GRILL Z", grill_z, "GRILL HEIGHT", grill_height, "GRILL TOP", grill_z + grill_height, "TOTAL HEIGHT", total_height);

module bolt_mount(cutout_offset) {
   difference() {
        cylinder(d=cyl_dia, h=total_height, center=true, $fn=99);
        
       translate([0,0,grill_z])
        cylinder(d=(hole_dia + 2.25), h=grill_height, $fn=99, center=true);
       
      translate([cutout_offset+(base_overhang / 2), 0, base_height/2])
          cube([base_overhang, cyl_dia, grill_height], center=true);
          
    }
}

module plate() {
    union() {
        //base
        cube([base_side_len, base_side_len, base_height], center=true);
  
        translate([0,0,grill_z]) 
            cube([grill_side_len, grill_side_len, grill_height], center=true);

        
    }
}

module grill() {
    for ( i = [1:1:3] ) {
        for ( j = [1:1:10] ) {
            //echo("X", grill_origin + ((j-1)*(rect_x + rect_x_pad)));
            //echo ("Y", ((i-1)*(rect_y+rect_y_pad)));
            translate([((j-1)*(rect_x + rect_x_pad)), ((i-1)*(rect_y+rect_y_pad)), -base_height / 2])
                cube([rect_x, rect_y, base_height + grill_height + 0.02], center=false);
        }
    }
}

difference() {
    union() {
        difference() {
            plate();
            translate([grill_origin, grill_origin, 0]) {
                grill();
            }
        }
         
        translate([-(base_side_len/ 2) + cyl_offset, 0, cyl_z - 0.01]) {
            bolt_mount(-cyl_offset);
        }
        translate([(base_side_len/ 2) - cyl_offset, 0, cyl_z - 0.01]) {
            bolt_mount(cyl_offset);
        }
    }
    // axtual 1/4" bolt holes
    translate([-(base_side_len/ 2) + cyl_offset, 0, cyl_z - 0.01])
        cylinder(d=hole_dia+0.01, h=total_height, center=true, $fn=99);
    translate([(base_side_len/ 2) - cyl_offset, 0, cyl_z - 0.01]) 
        cylinder(d=hole_dia+0.01, h=total_height, center=true, $fn=99);
}
