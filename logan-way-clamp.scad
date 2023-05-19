// plateau: 0.20" 5.08mm
// height: 0.5" 12.7mm
// width: 1.10" 27.94mm
// + 0.20 at base

difference() {
    linear_extrude( height=40 )
        polygon( points=[ [0,0], 
                        [85,0], 
                        [85,47.08],
                        [50, 47.08],
                        [50, 42], // bottom 
                        [37.3, 29.3], // top : implied 90
                        [32.22, 29.3], // plateau
                        [19.52, 42], // top
                        [19.52, 47.08], // bottom
                        // broken::w
    
                        // triangle:
                        //[50, 42], // bottom 
                        //[35, 29], // top : implied 90
                        //[27, 29], // plateau
                        //[17, 41], // top
                        //[17, 63], // bottom
                        //[28, 63],
                        //[28, 74],
                        //[0, 74] ] 
                        [19.52, 63],
                        [0, 63] ]
                        );
    // to create complete:
    //translate([-0.1, 54, -0.1])
    //    cube([18, 2, 41]);
    // to create top:
    translate([-0.1, 54, -0.1])
        cube([50, 24, 41]);
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
            
    cbore_dia = 10.47; // 0.411764 7/16	
    cbore_depth = 7.14; // .28089 25/89
    translate([center, -0.1, 10])
        rotate([-90, 0, 0])
            cylinder(d=cbore_dia, h=cbore_depth);
    translate([center, -0.1, 30])
        rotate([-90, 0, 0])
            cylinder(d=cbore_dia, h=cbore_depth);
}

