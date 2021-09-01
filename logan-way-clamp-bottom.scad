difference() {
    linear_extrude( height=40 )
        polygon( points=[ [0,0], 
                        [85,0], 
                        [85,47],
                        [50, 47],
                        [50, 42],
                        [35, 29],
                        [27, 29],
                        [17, 41], 
                        [17, 63],
                        [28, 63],
                        [28, 74],
                        [0, 74] ] );
    // to create complete:
    translate([-0.1, 54, -0.1])
        cube([18, 2, 41]);
    // to create top:
    //translate([-0.1, 54, -0.1])
    //    cube([50, 24, 41]);
    //to create bottom:
    //translate([-0.1, -0.1, -0.1])
    //    cube([86, 54, 41]);
    
    
    dia = 6.35 + 0.2;
    center = 17.0 / 2;
    depth = 86;
    translate([center, -0.1, 10])
        rotate([-90, 0, 0])
            cylinder(d=dia, h=depth);
    translate([center, -0.1, 30])
        rotate([-90, 0, 0])
            cylinder(d=dia, h=depth);
}

