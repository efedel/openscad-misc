line_width=0.08;
facets = (PI * 2) / line_width; //2mm dia

difference() {
    cube([10,15,10]);
    translate([5,10,0]) 
        cylinder(h=20, r=1, $fn=facets);
    
    rotate([90, 0, 0])
        translate([5,5,-16])
            cylinder(h=17, r=1, $fn=facets);

};