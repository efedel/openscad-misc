//reference"
//import("/tmp/Plant_Marker_-_Mint.stl");

// rect -100 to +50
// 50 mm triangle
//25 mm wide
// 5mm high

label = "lettuce";

L = 100.0; //150
PL = 25.0; //50
W = 15.0; //25
H = 4.0;

difference() {    
    union() {
        cube([L,W,H]);
        translate([L,0,0])
            linear_extrude(H)
                polygon(points=[
                    [0, 0],
                    [PL, (W / 2)], //50, 12.5
                    [0, W]
                    ]);
        /*
            polyhedron(points=[
                [0, 0, 0],
                [50, 12.5, 0], //50, 12.5
                [0, 25, 0],
                [0, 0, 5],
                [50, 12.5, 5], //50, 12.5
                [0, 25, 5]

        ], faces=[
                
                [0,3,5,2, 0], //back
                [0,3,4,1], //side
                [2,5,4,1],  //side
                [0, 1, 2, 0], // top
                [3, 4, 5, 3], // bottom
                
                //[1,4,7,6,1], //front
                
                //The points need to be listed clockwise when viewed from outside the polyhedron.
                // NOTE: These points are drawn in order like an outline!
                
                
        ]);
        */
    }
 
    translate([3, (W/3), -1]) {
        linear_extrude(H+2)
               text(label,size=8);
    }
}



