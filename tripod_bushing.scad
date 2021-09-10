b_dia = 14.125; //14.50; //14.75;
b_rad = (b_dia / 2);
t_dia = 10.50;
t_rad = (t_dia / 2);
h_dia = 3.87; //4; //3.85;
h_rad = (h_dia / 2);
x_dia = 8.75; //8.25; //8;
x_rad = (x_dia / 2);

// 6.84mm face to face, 7.81 edge to edge
// printed: 15.26 dia, hole 3.03 hex 6.30
// height 2.24 , 1.7 untapered
// dia is + 0.75
// height is - 0.75
// h_rad is + 1.00

difference() {
    union() {
        cylinder(h=(2.25 + 0.001), r=b_rad, $fn=999);
        translate([0, 0, 2]) cylinder(h=1.5, r1=b_rad, r2=t_rad, $fn=999);
    };
    translate([0, 0, -1]) {
        cylinder(h=(5 + 0.001), r=h_rad, $fn=999);
    };
    cylinder(h=2.25, r=x_rad, $fn=6);
};