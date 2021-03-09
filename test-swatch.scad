difference() {
    cube([20, 18, 5]);
    translate([1, 1, 4]) {
        cube([18,16,1]);
    };
    translate([6, 17, 0]) {
        rotate([0,0,-45]) {
            linear_extrude(height = 15) {
                text("yabba", size = 4, halign="left", valign="top",font = "Courier 10 Pitch");
            };
        };
    };
    translate([16.5, 14.5, 0]) {
        cylinder(h=6, r=1.5, $fn=100);
    }
};