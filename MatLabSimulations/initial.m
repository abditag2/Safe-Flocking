function [init dest] = initial(para)

initx = (2*rand(para.N,1)-1)*para.xybnd;
inity = (2*rand(para.N,1)-1)*para.xybnd;
destx = (2*rand(para.N,1)-1)*para.xybnd;
desty = (2*rand(para.N,1)-1)*para.xybnd;
inittheta = (2*rand(para.N,1)-1)*pi;
init = [initx inity zeros(para.N,1) inittheta];
dest = [destx desty];


%just changed from random to some known positions
%four robots
%init = [6.29447372786358,2.64718492450819,0,-0.491588359455165;8.11583874151238,-8.04919190001181,0,2.61214334354054;-7.46026367412988,-4.43003562265903,0,1.83599279973878;8.26751712278039,0.937630384099677,0,2.88707606227219] ;
%dest =  [3.99432206995939,7.76999277993085;-0.785055376170649,-7.14970964886133;-6.58813906727436,8.79343192545425;5.88742897262615,-9.99478289658939] ;

%two vehicles

%init = [-5   -5         0    3.14/4;
%    5    5       0  3.14+3.14/4;
%]    

%dest = [
%     5   5;
%    -5  -5;
%    ]

%three vehicles

%init = [-5   -5         0    3.14/4;
%    5    5       0  3.14+3.14/4;
%    -5    5       0  3.14+3.14*3/4;
%]    

%dest = [
%     5   5;
%    -5  -5;
%     5   -5;
%    ]

%four vehicles
init = [-5   -5         0    3.14/4;
    5    5       0  3.14+3.14/4;
    -5    5       0  3.14+3.14*3/4;
    5     -5    0    3.14*3/4;
]    

dest = [
     5   5;
    -5  -5;
     5   -5;
     -5   5 ;
    ]


end