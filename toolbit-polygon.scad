$blank_h = 9.525; // [6.35:15.875]
// toolbit height in mm (default: 9.5 [3/8"])
$blank_v = 9.525; // [6.35:15.875]
// toolbit length in mm (default: 100 [4"])
$blank_len = 101.6; // [25:200]

// tool angles - see tool-angle-nomeclature.png


$side_rake = 20; //[0:35]
$side_cutting_edge = 20; // [0:35]
$side_relief = 15; //[0:20]
$end_cutting_edge = 10; //[0:45]
$end_relief = 15;// [0:40]
$back_rake = 5; //5; // [-35:35]
$nose_radius = 0; // [0]

$face_len = $blank_h - ($blank_h / 5); // [0:15.875]

$pad = 0.001;

// 1 : side rake
//   1.1 : triangle to get coords of pivot point
opp = ($blank_h - $face_len);
//b = $blank_h;
scea = 270-$side_cutting_edge;
adj = opp / tan($side_cutting_edge);
//echo(H=$blank_h, L=$face_len, ADJ=c,OPP=a,A=scea,TAN_A=tan($side_cutting_edge));
// pivot point is now ($blank_h, cadj $blank_v)
sce_pivot_x = $blank_h;
sce_pivot_y = adj;
sce_pivot_z = $blank_v;
sce_length = opp / sin($side_cutting_edge); //c; // fixme: h!
sce_width = opp;

// 2: side relief
sr_length = sce_length * 1.5; //FIXME
sr_width = sce_width * 1.5; //FIXME
sr_height = (2 * $blank_v); //FIXME
// 3: side rake

// front cutting edge
f_adj = $face_len;
f_opp = (tan($end_cutting_edge) * f_adj);
f_h = f_adj / cos($end_cutting_edge);
// front relief
fr_adj = $blank_v;
fr_opp = (tan($end_relief) * fr_adj);
fr_h = fr_adj / cos($end_relief);

points = [ 
  [0,0],
  //...
];

paths = [ ];

polygon(points, paths);