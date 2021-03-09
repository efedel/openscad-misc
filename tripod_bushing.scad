b_dia = 14.50; //14.75;
b_rad = (b_dia / 2);
t_dia = 10.50;
t_rad = (t_dia / 2);
h_dia = 4; //3.85;
h_rad = (h_dia / 2);
x_dia = 8.25; //8;
x_rad = (x_dia / 2);

difference() {
    union() {
        cylinder(h=(2 + 0.001), r=b_rad, $fn=999);
        translate([0, 0, 2]) cylinder(h=1, r1=b_rad, r2=t_rad, $fn=999);
    };
    translate([0, 0, -1]) {
        cylinder(h=(4 + 0.001), r=h_rad, $fn=999);
    };
    cylinder(h=2, r=x_rad, $fn=6);
};